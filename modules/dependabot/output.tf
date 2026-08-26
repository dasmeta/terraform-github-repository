output "files" {
  value       = try(module.this[0].files, [])
  description = "The list of files created/commited by workflow module. Empty when no dependabot update is enabled, in which case no config file is written."
}

output "updates" {
  value       = local.enabled_updates
  description = "The resolved dependabot update entries written to the config file, after preset/legacy/custom selection and dropping disabled entries. Empty when no config file is written."
}
