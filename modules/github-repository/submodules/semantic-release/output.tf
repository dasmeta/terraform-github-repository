output "repository_name" {
  value = { for file in local.default_files : file.remote_path => github_repository_file.githooks-default-files[file.remote_path].commit_message }
}
