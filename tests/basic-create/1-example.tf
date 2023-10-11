module "this" {
  source = "../../"

  repositories = [{
    name               = "terraform-github-repository-test"
    archive_on_destroy = false
    branch_protections = []
  }]
}
