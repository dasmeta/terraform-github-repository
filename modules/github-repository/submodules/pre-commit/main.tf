resource "github_repository_file" "githooks-default-files" {
  for_each            = { for file in local.default_files : file.remote_path => file }
  repository          = var.repository_name
  branch              = var.branch_name
  file                = each.value.remote_path
  content             = file("${path.module}/${each.value.local_path}")
  commit_message      = "${local.commit_message}, Add ${each.value.remote_path}"
  overwrite_on_create = true
}

locals {
  default_files = [
    {
      remote_path = "git-conventional-commits.json"
      local_path  = "/resources/git-conventional-commits.json"
      }, {
      remote_path = "githooks/commit-msg"
      local_path  = "/resources/commit-msg"
      }, {
      remote_path = "githooks/pre-commit"
      local_path  = "/resources/pre-commit"
      }, {
      remote_path = ".pre-commit-config.yaml"
      local_path  = "/resources/pre-commit-config.yaml"
    }
  ]

  commit_message = "Initial commit"
}
