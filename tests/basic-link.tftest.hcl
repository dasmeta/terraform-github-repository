# Verifies the module plans cleanly when linking an existing repository instead
# of creating one, driven by the catalog-wide create_repository default.
#
# A successful plan is the assertion; see tests/basic-create.tftest.hcl.
#
# Requires GITHUB_TOKEN for the github provider.

provider "github" {
  owner = "dasmeta"
}

variables {
  defaults = {
    create_repository = false
    default_branch    = "main"
  }

  repositories = [{
    name = "terraform-null-empty"
  }]
}

run "basic_link_plans_cleanly" {
  command = plan
}
