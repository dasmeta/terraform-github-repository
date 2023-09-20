locals {
  merged_repositories = [
    for repo in var.repositories :
    merge(
      var.defaults,
      {
        "description" = repo.description,
        "name"        = repo.name,
        "tags"        = setunion(var.defaults.tags, repo.tags),
        "visibility"  = "public"
      }
    )
  ]
  repositories_map = { for repo in local.merged_repositories : repo.name => repo }
}

module "this" {
  source = "./modules/repository"

  for_each = local.repositories_map

  name             = each.value.name
  description      = each.value.description
  tags             = each.value.tags
  license_template = each.value.license_template
  homepage_url     = each.value.homepage_url
  visibility       = each.value.visibility
}
