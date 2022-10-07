resource "github_repository_webhook" "repository_webhook" {
  count = length(var.webhooks)

  repository = var.existing_repository == null ? github_repository.repository[0].name : data.github_repository.imported_github[0].name
  active     = try(var.webhooks[count.index].active, true)
  events     = var.webhooks[count.index].events

  configuration {
    url          = var.webhooks[count.index].url
    content_type = try(var.webhooks[count.index].content_type, "json")
    insecure_ssl = try(var.webhooks[count.index].insecure_ssl, false)
    secret       = try(var.webhooks[count.index].secret, null)
  }
}
