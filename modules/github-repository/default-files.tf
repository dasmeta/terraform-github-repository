resource "github_repository_file" "githooks-default-files" {
  depends_on          = [github_branch.branch]
  for_each            = { for file in var.default_files : file.remote_path => file if var.add_precommit }
  repository          = local.repository_name
  branch              = local.branch_name
  file                = each.value.remote_path
  content             = templatefile("${path.module}/${each.value.local_path}", { project_name = var.project_name })
  commit_message      = local.commit_message
  overwrite_on_create = true
}

resource "github_repository_file" "user-files" {
  depends_on          = [github_branch.branch]
  for_each            = { for file in var.init_files : file.remote_path => file }
  repository          = local.repository_name
  branch              = local.branch_name
  file                = each.value.remote_path
  content             = file("./${each.value.local_path}")
  commit_message      = local.commit_message
  overwrite_on_create = true
}
