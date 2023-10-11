module "this" {
  source = "../../"

  repositories = [{
    name               = "terraform-github-repository-full-enabled-test"
    archive_on_destroy = false
    visibility         = "public"
    create_repository  = true
    description        = "Test repository created by terraform"

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
    terraform-test         = true
    tflint                 = true
    tfsec                  = true
    dependabot             = { enabled : true, ecosystems = ["github-actions", "terraform"] }
    pull_request           = { create : true }
  }]
}
