resource "github_actions_secret" "repository_secret" {
  for_each = local.secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = try(each.value.plaintext, null)
  encrypted_value = try(each.value.encrypted, null)
}

resource "github_actions_secret" "example_secret" {
  for_each        = { for secret in var.secrets : secret.secret_name => secret.plaintext_value }
  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = each.value
}
