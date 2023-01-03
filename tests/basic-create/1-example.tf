module "this" {
  source = "../../"

  name               = "terraform-github-repository-test"
  default_branch     = "main"
  visibility         = "private"
  archive_on_destroy = false
}
