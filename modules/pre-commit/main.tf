module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables = {
    actions_version              = var.actions_version
    terraform_docs_version       = var.terraform_docs_version
    pre_commit_terraform_version = var.pre_commit_terraform_version
  }
  files = [
    {
      remote_path = "git-conventional-commits.json"
      local_path  = "${path.module}/templates/git-conventional-commits.json.tftpl"
      }, {
      remote_path = "githooks/commit-msg"
      local_path  = "${path.module}/templates/commit-msg.sh.tftpl"
      }, {
      remote_path = "githooks/pre-commit"
      local_path  = "${path.module}/templates/pre-commit.sh.tftpl"
      }, {
      remote_path = ".github/workflows/pre-commit.yaml"
      local_path  = "${path.module}/templates/pre-commit.yaml.tftpl"
      }, {
      remote_path = ".pre-commit-config.yaml"
      local_path  = "${path.module}/templates/.pre-commit-config.yaml.tftpl"
      }, {
      # Documentation behaviour is committed to the repository rather than
      # passed as hook flags, so a local run and a CI run agree.
      remote_path = ".terraform-docs.yml"
      local_path  = "${path.module}/templates/.terraform-docs.yml.tftpl"
    }
  ]
}
