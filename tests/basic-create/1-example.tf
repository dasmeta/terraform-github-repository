module "this" {
  source = "../../"

  name               = "terraform-github-repository-test"
  archive_on_destroy = false
  branch_protections = []
}
