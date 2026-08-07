# Replaces the removed terraform.io/builtin/test assertions.
# Requires GITHUB_TOKEN for the github provider, see 0-setup.tf.
#
# full_name is only known after apply for a created repository, so the plan
# level check asserts on the resolved name.

run "plan" {
  command = plan

  assert {
    condition     = output.name == "terraform-github-test-repo"
    error_message = "the module must resolve the repository name for both created and linked repositories"
  }
}
