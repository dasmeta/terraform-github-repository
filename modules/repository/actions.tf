resource "github_actions_repository_permissions" "actions" {
  allowed_actions = var.enable_github_actions

  dynamic "allowed_actions_config" {
    for_each = var.allowed_github_actions_config != null ? [1] : []

    content {
      github_owned_allowed = var.allowed_github_actions_config.github_owned_allowed
      patterns_allowed     = var.allowed_github_actions_config.patterns_allowed
      verified_allowed     = var.allowed_github_actions_config.verified_allowed
    }
  }
  repository = github_repository.repository[0].name
}
