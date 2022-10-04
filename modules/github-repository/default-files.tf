resource "github_repository_file" "githooks-default-files" {
  for_each   = { for file in var.default_files : file.remote_path => file if var.add_precommit }
  repository = github_repository.repository.name
  branch     = "main"
  file       = each.value.remote_path
  content    = templatefile("${path.module}/${each.value.local_path}", { project_name = var.project_name })
  #content             = local.x

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

locals {
  x = templatefile("${path.module}/resources/branch-name-check.yaml", { project_name = "DMVP" })
}
