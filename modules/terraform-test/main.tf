module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { paths = var.paths, aws-region = var.aws-region, aws-access-key-id = var.aws-access-key-id, aws-secret-access-key = var.aws-secret-access-key, path = var.path }
  files = [
    {
      remote_path = ".github/workflows/terraform-test.yaml"
      local_path  = "${path.module}/templates/terraform-test.yaml.tftpl"
    }
  ]
}
