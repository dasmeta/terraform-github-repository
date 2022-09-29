resource "github_repository" "repository" {
  name                   = var.name
  description            = var.description
  homepage_url           = var.homepage_url
  visibility             = var.visibility
  has_issues             = var.has_issues
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  allow_merge_commit     = var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  is_template            = var.is_template
  has_downloads          = var.has_downloads
  auto_init              = var.auto_init
  gitignore_template     = var.gitignore_template
  license_template       = var.license_template
  archived               = var.archived
  topics                 = var.topics

  archive_on_destroy   = var.archive_on_destroy
  vulnerability_alerts = var.vulnerability_alerts

  dynamic "template" {
    for_each = local.template

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }

  dynamic "pages" {
    for_each = var.pages != null ? [true] : []

    content {
      source {
        branch = var.pages.branch
        path   = try(var.pages.path, "/")
      }
      cname = try(var.pages.cname, null)
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      auto_init,
      license_template,
      gitignore_template,
      template,
    ]
  }
}
