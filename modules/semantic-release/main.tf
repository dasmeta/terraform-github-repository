module "this" {
  source = "../workflow-files-base"

  repository = var.repository_name
  branch     = var.branch_name
  files = [
    {
      remote_path = ".github/workflows/semantic-release.yaml"
      local_path  = "${path.module}/templates/semantic-release.yaml.tftpl"
      }, {
      remote_path = "package.json"
      local_path  = "${path.module}/templates/package.json.tftpl"
      }, {
      remote_path = "commitlint.config.js"
      local_path  = "${path.module}/templates/commitlint.config.js.tftpl"
    }
  ]
}
