variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "project_name" {
  description = "Project name for branch name checking e.g 'DMVP-' "
  type        = string
  default     = "DMVP"
}
