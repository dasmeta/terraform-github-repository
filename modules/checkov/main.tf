module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { paths = var.paths, path = var.path }
  files = [
    {
      remote_path = ".github/workflows/checkov.yaml"
      local_path  = "${path.module}/templates/checkov.yaml.tftpl"
    }
  ]
}
