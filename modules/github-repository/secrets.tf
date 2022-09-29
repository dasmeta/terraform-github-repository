resource "github_actions_secret" "repository_secret" {
  for_each = local.secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = try(each.value.plaintext, null)
  encrypted_value = try(each.value.encrypted, null)
}
