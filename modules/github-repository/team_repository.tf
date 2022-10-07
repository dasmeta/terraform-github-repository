resource "github_team_repository" "team_repository" {
  count = length(local.team_ids)

  repository = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  team_id    = local.team_ids[count.index].team_id
  permission = local.team_ids[count.index].permission
}

resource "github_team_repository" "team_repository_by_slug" {
  for_each = local.teams

  repository = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  team_id    = each.value.slug
  permission = each.value.permission

  depends_on = [var.module_depends_on]
}
