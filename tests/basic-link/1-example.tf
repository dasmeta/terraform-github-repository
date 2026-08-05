module "this" {
  source = "../../"

  # linking an existing repository is a catalog-wide setting, the repositories
  # entry schema only accepts name/description/topics/pages
  defaults = {
    create_repository = false
    default_branch    = "main"
  }

  repositories = [{
    name = "terraform-null-empty"
    }
  ]
}
