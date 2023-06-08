module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  files = [
    {
      remote_path = ".github/workflows/tfsec.yaml"
      local_path  = "${path.module}/templates/tfsec.yaml.tftpl"
    }
  ]
}
