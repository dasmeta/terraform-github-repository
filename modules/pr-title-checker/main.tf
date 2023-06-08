module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { project_name = var.project_name }
  files = [
    {
      remote_path = ".github/workflows/pr-title-checker.yaml"
      local_path  = "${path.module}/templates/pr-title-checker.yaml.tftpl"
    }
  ]
}
