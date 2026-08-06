module "this" {
  source = "../../"

  # a repositories entry only accepts name/description/topics/pages, every other
  # setting is configured for the whole set through defaults
  defaults = {
    archive_on_destroy = false
    visibility         = "public"
    create_repository  = true

    branches      = ["best-practices"]
    branch_toPush = "best-practices"

    has_issues             = true
    has_projects           = true
    has_wiki               = true
    auto_init              = true
    delete_branch_on_merge = true
    gitignore_template     = "Terraform"
    allow_auto_merge       = false
    allow_rebase_merge     = true
    infracost              = true
    pre_commit             = true
    semantic_release       = true
    checkov                = true
    terraform_test         = true
    tflint                 = true
    trivy                  = true
    dependabot             = { enabled : true, ecosystems = ["github-actions", "terraform"] }
    pull_request           = { create : true }
  }

  repositories = [{
    name        = "terraform-github-repository-full-enabled-test"
    description = "Test repository created by terraform"
  }]
}
