resource "github_repository_collaborator" "collaborator" {
  for_each = local.collaborators

  repository = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  username   = each.key
  permission = each.value
}
