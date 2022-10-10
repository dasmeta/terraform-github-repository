resource "github_team_repository" "team_repository" {
  count = length(local.team_ids)

  repository = local.repository_name
  team_id    = local.team_ids[count.index].team_id
  permission = local.team_ids[count.index].permission
}

resource "github_team_repository" "team_repository_by_slug" {
  for_each = local.teams

  repository = local.repository_name
  team_id    = each.value.slug
  permission = each.value.permission

  depends_on = [var.module_depends_on]
}
