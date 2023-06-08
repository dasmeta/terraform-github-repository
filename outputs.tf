output "name" {
  value       = local.repository_name
  description = "The name of git repo without org/owner"
}

output "full_name" {
  value       = local.full_name
  description = "The name of git repo with org.owner in form '{owner}/{name}'"
}

output "files" {
  value = merge(

  )
  description = "The list of all files created/commited"
}
