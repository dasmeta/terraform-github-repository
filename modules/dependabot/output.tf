output "files" {
  value       = try(module.this[0].files, [])
  description = "The list of files created/commited by workflow module. Empty when no dependabot update is enabled, in which case no config file is written."
}
