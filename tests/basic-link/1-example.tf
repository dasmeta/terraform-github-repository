module "this" {
  source = "../../"

  repositories = [{
    name              = "terraform-null-empty"
    default_branch    = "main"
    create_repository = false
    }
  ]
}
