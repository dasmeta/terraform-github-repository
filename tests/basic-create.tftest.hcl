# Verifies the module plans cleanly for a minimal single-repository catalog.
#
# The root module exposes no outputs, so a successful plan is the assertion for
# this case: it proves the input shape type-checks and the child module wiring
# resolves. Richer assertions require adding root outputs, tracked separately.
#
# Requires GITHUB_TOKEN for the github provider.

provider "github" {
  owner = "dasmeta"
}

variables {
  defaults = {
    archive_on_destroy = false
    branch_protections = []
  }

  repositories = [{
    name = "terraform-github-repository-test"
  }]
}

run "basic_create_plans_cleanly" {
  command = plan
}
