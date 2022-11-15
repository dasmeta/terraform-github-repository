resource "github_repository_file" "githooks-default-files" {
  for_each            = { for file in local.default_files : file.remote_path => file }
  repository          = var.repository_name
  branch              = var.branch_name
  file                = each.value.remote_path
  content             = templatefile("${path.module}/${each.value.local_path}", { paths = var.paths, aws-region = var.aws-region, aws-access-key-id = var.aws-access-key-id, aws-secret-access-key = var.aws-secret-access-key, path = var.path, repo-token = var.repo-token })
  commit_message      = "${local.commit_message}, Add ${each.value.remote_path}"
  overwrite_on_create = true

}

locals {
  default_files = [
    {
      remote_path = ".github/workflows/tflint.yaml"
      local_path  = "resources/tflint.yaml.tpl"
    }
  ]

  commit_message = "Initial commit"
}
