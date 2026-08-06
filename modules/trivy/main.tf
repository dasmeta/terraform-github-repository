module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  files = [
    {
      remote_path = ".github/workflows/trivy.yaml"
      local_path  = "${path.module}/templates/trivy.yaml.tftpl"
    }
  ]
}
