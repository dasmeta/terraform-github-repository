resource "github_repository_file" "githooks-default-files" {
  for_each            = { for file in var.default_files : file.remote_path => file if var.add_precommit }
  repository          = github_repository.repository.name
  branch              = "main"
  file                = each.value.remote_path
  content             = file("${path.module}/${each.value.local_path}")
  commit_message      = var.commit_message
  overwrite_on_create = true
}

resource "github_repository_file" "user-files" {
  for_each            = { for file in var.init_files : file.remote_path => file }
  repository          = github_repository.repository.name
  branch              = "main"
  file                = each.value.remote_path
  content             = file("./${each.value.local_path}")
  commit_message      = var.commit_message
  overwrite_on_create = true
}
