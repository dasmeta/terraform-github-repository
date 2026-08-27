# Regression coverage for the generated Terraform validation workflow.
#
# The assertions render the real template and parse the YAML, rather than
# checking locals. The defects this change fixes lived in the rendered
# workflow: a required context that never existed, a job that could not fail,
# and credentials demanded by modules that have no AWS provider. A test that
# stopped at the inputs would have passed against all three.
#
# The github provider is mocked: the workflow body is templatefile output over
# static inputs, so everything asserted here is known at plan time.

mock_provider "github" {}

variables {
  repository_name = "example-repo"
  branch_name     = "main"
}

run "stable_required_context_exists_alongside_matrix_detail" {
  command = plan

  variables {
    paths = ["./", "./modules/first", "./modules/second"]
  }

  assert {
    condition     = can(yamldecode(output.workflow).jobs["terraform-validate"])
    error_message = "A job named terraform-validate must exist, because that is the context branch protection requires."
  }

  assert {
    condition     = yamldecode(output.workflow).jobs.validate.strategy.matrix.path == ["./", "./modules/first", "./modules/second"]
    error_message = "Every configured path must get its own matrix leg for per-path visibility."
  }

  assert {
    condition     = yamldecode(output.workflow).jobs["terraform-validate"].needs == ["validate"]
    error_message = "The required context must depend on the matrix job, otherwise it reports success while validation fails."
  }
}

run "matrix_does_not_hide_failures" {
  command = plan

  variables {
    paths = ["./", "./modules/first"]
  }

  assert {
    condition     = yamldecode(output.workflow).jobs.validate.strategy.fail-fast == false
    error_message = "fail-fast must stay off; otherwise one failing path cancels the rest and their results are never reported."
  }

  assert {
    condition     = !strcontains(output.workflow, "continue-on-error")
    error_message = "continue-on-error must not appear: a validation failure has to fail the required gate."
  }
}

run "validate_mode_needs_no_aws_credentials" {
  command = plan

  variables {
    mode = "validate"
  }

  assert {
    condition     = !strcontains(output.workflow, "aws-access-key-id")
    error_message = "Provider-independent validation must not configure AWS credentials."
  }

  assert {
    condition     = strcontains(output.workflow, "terraform init -backend=false")
    error_message = "validate mode must initialize without a backend."
  }
}

run "test_mode_uses_the_shared_action_with_credentials" {
  command = plan

  assert {
    condition     = strcontains(output.workflow, "dasmeta/reusable-actions-workflows/terraform-test@4.4.0")
    error_message = "test mode must call the shared action at the pinned release."
  }

  assert {
    condition     = !strcontains(output.workflow, "terraform init -backend=false")
    error_message = "test mode must not emit the provider-independent validate steps."
  }
}

run "rejects_unknown_mode" {
  command = plan

  variables {
    mode = "lint"
  }

  expect_failures = [var.mode]
}
