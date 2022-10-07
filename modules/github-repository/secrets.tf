resource "github_actions_secret" "repository_secret" {
  for_each = local.secrets

  repository      = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  secret_name     = each.key
  plaintext_value = try(each.value.plaintext, null)
  encrypted_value = try(each.value.encrypted, null)
}

resource "github_actions_secret" "example_secret" {
  for_each        = { for secret in var.secrets : secret.secret_name => secret.plaintext_value }
  repository      = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  secret_name     = each.key
  plaintext_value = each.value
}
