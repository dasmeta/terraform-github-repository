resource "github_repository_file" "this" {
  for_each = { for file in var.files : file.remote_path => file }

  repository          = var.repository
  branch              = var.branch
  file                = each.value.remote_path
  content             = templatefile(each.value.local_path, var.variables)
  commit_message      = "${var.commit_message_prefix}, Add ${each.value.remote_path}"
  overwrite_on_create = var.overwrite_on_create
}
