resource "github_repository_file" "githooks-semantic-release" {
  for_each   = { for file in var.local_remote_list : file.remote_name => file }
  repository = github_repository.repository.name
  branch     = "main"
  file       = each.value.remote_name
  content    = file("${path.module}/${each.value.local_name}")
  #file = ".github/workflows/commitlint.yaml"
  # content ="${path.module}/resources/commitlint.yaml"
  commit_message      = var.commit_message
  overwrite_on_create = true
}

variable "local_remote_list" {
  type = list(object({
    remote_name = string
    local_name  = string
  }))
  default = [{
    remote_name = ".github/workflows/commitlint.yaml"
    local_name  = "/resources/semantic-release.yaml"
    }, {
    remote_name = ".pre-commit-config.yaml"
    local_name  = "/resources/pre-commit-config.yaml"
    }, {
    remote_name = "githooks/pre-commit"
    local_name  = "/resources/pre-commit"
    }, {
    remote_name = ".github/workflows/pre-commit.yaml"
    local_name  = "/resources/pre-commit.yaml"
    }, {
    remote_name = ".github/workflows/pr-title-checker.yaml"
    local_name  = "/resources/pr-title-checker.yaml"
  }]
}
