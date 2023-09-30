module "this" {
  source = "../../"

  name     = "terraform-github-test-repo"
  branches = []
  pull_request = {
    create = false
  }
}
