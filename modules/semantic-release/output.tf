output "files" {
  value       = module.this.files
  description = "The list of files created/commited by workflow module"
}

output "workflow" {
  value       = file("${path.module}/templates/semantic-release.yaml.tftpl")
  description = "The rendered publishing workflow, exposed so regression tests assert on generated content."
}
