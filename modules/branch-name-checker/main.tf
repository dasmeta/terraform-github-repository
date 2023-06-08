module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { project_name = var.project_name }
  files = [
    {
      remote_path = ".github/workflows/branch-name-check.yaml"
      local_path  = "${path.module}/templates/branch-name-check.yaml.tftpl"
    }
  ]
}
