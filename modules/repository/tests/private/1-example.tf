module "this" {
  source = "../../"

  name                 = "terraform-github-test-repo"
  branch_protections   = []
  default_branch       = "main"
  description          = "test description"
  has_downloads        = true
  has_discussions      = true
  vulnerability_alerts = true
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  homepage_url         = "dasmeta.com"
  visibility           = "private"
  pull_request = {
    create = false
  }
}
