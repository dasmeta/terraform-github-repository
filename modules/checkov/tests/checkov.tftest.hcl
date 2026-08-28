# Regression coverage for the generated checkov workflow.
#
# Both defects here were invisible from the module inputs and only became
# visible once the pre-commit gate could fail: the loop emitted a line of
# stray whitespace into every generated file, and the job was named
# terraform-validate, which is neither what it does nor unique across the
# generated workflows.

mock_provider "github" {}

variables {
  repository_name = "example-repo"
  branch_name     = "main"
}

run "renders_no_trailing_whitespace" {
  command = plan

  variables {
    paths = ["./", "./modules/first"]
  }

  # The trailing-whitespace hook rewrites any such line, which counts as
  # "files were modified by this hook" and fails the run. Every managed
  # repository hit this on the first blocking pre-commit run.
  assert {
    condition = length([
      for line in split("\n", output.workflow) : line
      if line != trimspace(line) && trimspace(line) == ""
    ]) == 0
    error_message = "The generated workflow must contain no whitespace-only lines."
  }

  assert {
    condition     = yamldecode(output.workflow).jobs.checkov.strategy.matrix.path == ["./", "./modules/first"]
    error_message = "Every configured path must render as its own matrix leg."
  }
}

run "job_name_is_distinct" {
  command = plan

  assert {
    condition     = can(yamldecode(output.workflow).jobs.checkov)
    error_message = "The job must be named checkov, so its status context says what actually ran."
  }

  assert {
    condition     = !can(yamldecode(output.workflow).jobs["terraform-validate"])
    error_message = "checkov must not claim the terraform-validate name; it does not run terraform validation, and two workflows using it produced byte-identical contexts."
  }
}

run "paths_default_to_the_repository_root" {
  command = plan

  # "/" is the filesystem root. Consumers had been correcting this by hand.
  assert {
    condition     = yamldecode(output.workflow).jobs.checkov.strategy.matrix.path == ["./"]
    error_message = "The default path must be the repository root, not the filesystem root."
  }
}
