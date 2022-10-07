resource "github_repository_file" "githooks-default-files" {
  depends_on          = [github_branch.best-practice-branch]
  for_each            = { for file in var.default_files : file.remote_path => file if var.add_precommit }
  repository          = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  branch              = var.existing_repository == null ? "main" : var.existing_repository.branch_toPush
  file                = each.value.remote_path
  content             = templatefile("${path.module}/${each.value.local_path}", { project_name = var.project_name })
  commit_message      = var.existing_repository == null ? var.commit_message : var.existing_repository.commit_message
  overwrite_on_create = true
}

resource "github_repository_file" "user-files" {
  depends_on          = [github_branch.best-practice-branch]
  for_each            = { for file in var.init_files : file.remote_path => file }
  repository          = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  branch              = var.existing_repository == null ? "main" : var.existing_repository.branch_toPush
  file                = each.value.remote_path
  content             = file("./${each.value.local_path}")
  commit_message      = var.existing_repository == null ? var.commit_message : var.existing_repository.commit_message
  overwrite_on_create = true
}
