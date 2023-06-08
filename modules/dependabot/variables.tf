variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "ecosystems" {
  description = "The list of tool/ecosystems to monitor and identify new realizes/version to prepare upgrades/prs"
  type        = list(string)
  default     = []
}
