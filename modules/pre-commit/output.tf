output "files" {
  value       = module.this.files
  description = "The list of files created/commited by workflow module"
}

output "pre_commit_config" {
  value = templatefile("${path.module}/templates/.pre-commit-config.yaml.tftpl", {
    pre_commit_terraform_version = var.pre_commit_terraform_version
  })
  description = "The rendered .pre-commit-config.yaml, exposed for regression tests."
}

output "terraform_docs_config" {
  value       = file("${path.module}/templates/.terraform-docs.yml.tftpl")
  description = "The rendered .terraform-docs.yml, exposed for regression tests."
}

output "workflow" {
  value = templatefile("${path.module}/templates/pre-commit.yaml.tftpl", {
    actions_version        = var.actions_version
    terraform_docs_version = var.terraform_docs_version
  })
  description = "The rendered pre-commit workflow, exposed for regression tests."
}
