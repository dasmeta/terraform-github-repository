module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables = {
    paths                 = var.paths
    mode                  = var.mode
    terraform_version     = var.terraform_version
    actions_version       = var.actions_version
    aws-region            = var.aws-region
    aws-access-key-id     = var.aws-access-key-id
    aws-secret-access-key = var.aws-secret-access-key
  }
  files = [
    {
      remote_path = ".github/workflows/terraform-test.yaml"
      local_path  = "${path.module}/templates/terraform-test.yaml.tftpl"
    }
  ]
}
