variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "path_to_module" {
  description = "Path to terraform configuration (Usually module) to run terraform-plan"
  type        = string
  default     = "./modules"
}

variable "module_variables" {
  description = "We can use terraform apply GitHub action and set variables for modules"
  type        = map(string)
  default     = {}
}
