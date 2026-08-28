output "files" {
  value       = module.this.files
  description = "The list of files created/commited by workflow module"
}

output "workflow" {
  value = templatefile("${path.module}/templates/tflint.yaml.tftpl", {
    paths                 = var.paths
    path                  = var.path
    repo-token            = var.repo-token
    aws-region            = var.aws-region
    aws-access-key-id     = var.aws-access-key-id
    aws-secret-access-key = var.aws-secret-access-key
  })
  description = "The rendered workflow body, exposed so regression tests assert on generated content."
}
