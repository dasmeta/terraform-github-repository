resource "github_branch" "branch" {
  for_each = toset(coalesce(var.branches, []))

  repository = local.repository_name
  branch     = each.key
}

resource "github_branch_default" "default" {
  count = var.default_branch != null ? 1 : 0

  repository = local.repository_name
  branch     = var.default_branch

  depends_on = [github_branch.branch]
}

resource "github_branch_protection_v3" "branch_protection" {
  count = length(local.branch_protections)

  depends_on = [
    github_repository_collaborator.collaborator,
    github_team_repository.team_repository,
    github_team_repository.team_repository_by_slug,
    github_branch.branch,
  ]

  repository                      = local.repository_name
  branch                          = local.branch_protections[count.index].branch
  enforce_admins                  = local.branch_protections[count.index].enforce_admins
  require_conversation_resolution = local.branch_protections[count.index].require_conversation_resolution
  require_signed_commits          = local.branch_protections[count.index].require_signed_commits
  dynamic "required_status_checks" {
    for_each = local.required_status_checks[count.index]
    content {
      strict = required_status_checks.value.strict
      checks = required_status_checks.value.checks
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = local.required_pull_request_reviews[count.index]

    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      dismissal_users                 = required_pull_request_reviews.value.dismissal_users
      dismissal_teams                 = [for t in required_pull_request_reviews.value.dismissal_teams : replace(lower(t), "/[^a-z0-9_]/", "-")]
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
    }
  }

  dynamic "restrictions" {
    for_each = local.restrictions[count.index]

    content {
      users = restrictions.value.users
      teams = [for t in restrictions.value.teams : replace(lower(t), "/[^a-z0-9_]/", "-")]
      apps  = restrictions.value.apps
    }
  }
}

resource "github_repository_pull_request" "this" {
  count = try(var.pull_request.create, false) ? 1 : 0

  base_repository = local.repository_name
  base_ref        = coalesce(var.pull_request.base_ref, var.default_branch)
  head_ref        = var.branch_toPush
  title           = var.pull_request.title
  body            = var.pull_request.body

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo,
    github_branch_default.default
  ]
}
