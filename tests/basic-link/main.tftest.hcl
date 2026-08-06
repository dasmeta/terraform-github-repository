# Replaces the removed terraform.io/builtin/test assertions.
# The module exposes no outputs, so the check is that the example plans cleanly.
# Requires GITHUB_TOKEN for the github provider, see 0-setup.tf.

run "plan" {
  command = plan
}
