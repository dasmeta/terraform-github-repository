# Regression coverage for the generated pre-commit and documentation setup.
#
# Every defect this change fixes was visible only in the rendered files: a hook
# invoked with flags that appended a second documentation block, a workflow
# referencing a matrix that did not exist, and a job name shared with another
# workflow. The assertions therefore parse what gets written to the repository.

mock_provider "github" {}

variables {
  repository_name = "example-repo"
  branch_name     = "main"
}

run "docs_hook_reads_the_committed_config" {
  command = plan

  assert {
    condition = yamldecode(output.pre_commit_config).repos[1].hooks[1].args == [
      "--args=--config=.terraform-docs.yml",
    ]
    error_message = "Documentation behaviour must come from the committed .terraform-docs.yml, so a local run and CI agree."
  }

  # Asserted against the parsed args rather than the raw file: the template
  # names both flags in a comment explaining why they were removed, and a
  # string match cannot tell an explanation from an instruction.
  assert {
    condition = length([
      for arg in yamldecode(output.pre_commit_config).repos[1].hooks[1].args :
      arg if strcontains(arg, "add-to-existing-file")
    ]) == 0
    error_message = "add-to-existing-file used the hook's own markers and appended a second block to READMEs that already had terraform-docs markers."
  }

  assert {
    condition = length([
      for arg in yamldecode(output.pre_commit_config).repos[1].hooks[1].args :
      arg if strcontains(arg, "create-file-if-not-exist")
    ]) == 0
    error_message = "create-file-if-not-exist generated READMEs in examples and test fixtures that nobody asked for."
  }
}

run "docs_config_uses_native_markers_and_does_not_invent_files" {
  command = plan

  assert {
    condition     = yamldecode(output.terraform_docs_config).output.mode == "inject"
    error_message = "inject writes between the terraform-docs markers and leaves the rest of the README alone."
  }

  assert {
    condition     = yamldecode(output.terraform_docs_config).output.file == "README.md"
    error_message = "The hook reads output.file from this config in preference to its own flag, so it has to be set here."
  }
}

run "hook_release_migrates_legacy_markers" {
  command = plan

  # v1.93 introduced replace_old_markers, which rewrites a legacy
  # BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK pair into BEGIN_TF_DOCS in
  # place. Pinning below that leaves every existing README unmigrated.
  assert {
    condition     = tonumber(split(".", trimprefix(var.pre_commit_terraform_version, "v"))[1]) >= 93
    error_message = "pre-commit-terraform must be at least v1.93, which migrates the legacy documentation markers in place."
  }
}

run "workflow_has_no_undefined_matrix_and_cannot_fail_open" {
  command = plan

  assert {
    condition     = !strcontains(output.workflow, "matrix.path")
    error_message = "The workflow referenced matrix.path with no strategy block, so the path resolved to modules/ and the wrong directory was checked."
  }

  assert {
    condition     = !strcontains(output.workflow, "continue-on-error")
    error_message = "continue-on-error must not appear: a hook failure has to fail the gate."
  }

  assert {
    condition     = can(yamldecode(output.workflow).jobs["pre-commit"])
    error_message = "The job must be named pre-commit, not terraform-validate, which collided with the job in terraform-test.yaml."
  }

  assert {
    condition     = !can(yamldecode(output.workflow).jobs["terraform-validate"])
    error_message = "Two workflows reporting the same status context leaves branch protection unable to tell which one it requires."
  }
}

run "workflow_pins_an_action_release_that_can_fail" {
  command = plan

  # Before 4.4.0 the pre-commit action carried continue-on-error on both its
  # run and check steps, and its check was `grep -q "Failed"`, which succeeds
  # when hooks fail. Requiring its context gated nothing.
  assert {
    condition     = strcontains(output.workflow, "dasmeta/reusable-actions-workflows/pre-commit@4.4.0")
    error_message = "The workflow must pin an action release that reports failure."
  }

  assert {
    condition     = strcontains(output.workflow, "terraform-docs-version: 0.20.0")
    error_message = "CI must install the same terraform-docs version the repositories have committed."
  }
}
