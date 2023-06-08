module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { paths = var.paths, secret = var.secret, ref = var.ref, path = var.path, token = var.token, pr = var.pr }
  files = [
    {
      remote_path = ".github/workflows/infracost.yaml"
      local_path  = "${path.module}/templates/infracost.yaml.tftpl"
    }
  ]
}
