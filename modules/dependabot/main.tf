module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { ecosystems = var.ecosystems }
  files = [
    {
      remote_path = ".github/dependabot.yaml"
      local_path  = "${path.module}/templates/dependabot.yaml.tftpl"
    }
  ]
}
