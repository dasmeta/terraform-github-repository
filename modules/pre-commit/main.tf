module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
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
    }
  ]
}
