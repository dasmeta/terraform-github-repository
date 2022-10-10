resource "github_repository_collaborator" "collaborator" {
  for_each = local.collaborators

  repository = local.repository_name
  username   = each.key
  permission = each.value
}
