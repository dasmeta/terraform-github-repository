output "files" {
  value       = module.this.files
  description = "The list of files created/commited by workflow module"
}

output "workflow" {
  value = templatefile("${path.module}/templates/checkov.yaml.tftpl", {
    paths = var.paths
    path  = var.path
  })
  description = "The rendered workflow body, exposed so regression tests assert on generated content."
}
