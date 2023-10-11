module "this" {
  source = "../../"

  name                 = "terraform-github-test-repo"
  default_branch       = "main"
  description          = "test description"
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  allow_merge_commit   = true
  gitignore_template   = true
  allow_rebase_merge   = true
  allow_squash_merge   = true
  has_downloads        = true
  has_discussions      = true
  vulnerability_alerts = true
  branch_protections = [
    {
      branch                 = "main"
      enforce_admins         = true
      require_signed_commits = false
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }
    }
  ]
  branch_name_checker    = true
  pr_description_checker = true
  pr_title_checker       = true
  pre_commit             = true
  semantic_release       = true
  checkov                = true
  infracost              = true
  terraform_test         = true
  tflint                 = true
  tfsec                  = true
  dependabot = {
    enabled = true
  }
  homepage_url = "dasmeta.com"
  visibility   = "public"
}
