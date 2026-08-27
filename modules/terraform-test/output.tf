output "files" {
  value       = module.this.files
  description = "The list of files created/commited by workflow module"
}

output "workflow" {
  value = templatefile("${path.module}/templates/terraform-test.yaml.tftpl", {
    paths                 = var.paths
    mode                  = var.mode
    terraform_version     = var.terraform_version
    actions_version       = var.actions_version
    aws-region            = var.aws-region
    aws-access-key-id     = var.aws-access-key-id
    aws-secret-access-key = var.aws-secret-access-key
  })
  description = <<-EOT
    The rendered workflow body. Exposed so regression tests can assert against
    what is actually written to the repository rather than against the inputs,
    which is where the defects this module fixes lived.
  EOT
}
