module "this" {
  source = "../../"

  # a repositories entry only accepts name/description/topics/pages, every other
  # setting is configured for the whole set through defaults
  defaults = {
    archive_on_destroy = false
    branch_protections = []
  }

  repositories = [{
    name = "terraform-github-repository-test"
  }]
}
