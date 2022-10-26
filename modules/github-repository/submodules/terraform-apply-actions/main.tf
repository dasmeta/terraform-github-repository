resource "github_repository_file" "githooks-default-files" {
  for_each            = { for file in local.default_files : file.remote_path => file }
  repository          = var.repository_name
  branch              = var.branch_name
  file                = each.value.remote_path
  content             = templatefile("${path.module}/${each.value.local_path}", { path_to_module = var.path_to_module, variables = var.module_variables })
  commit_message      = "${local.commit_message}, Add ${each.value.remote_path}"
  overwrite_on_create = true
}

locals {
  default_files = [
    {
      remote_path = ".github/workflows/semantic-release.yaml"
      local_path  = "/resources/semantic-release.yaml"
      }, {
      remote_path = "package.json"
      local_path  = "/resources/package.json"
    }
  ]

  commit_message = "Initial commit"

}
