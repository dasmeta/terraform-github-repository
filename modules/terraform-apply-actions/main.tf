module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { path_to_module = var.path_to_module, variables = var.module_variables }
  files = [
    {
      remote_path = ".github/workflows/terraform-apply.yaml"
      local_path  = "${path.module}/templates/terraform-apply.yaml.tftpl"
    }
  ]
}
