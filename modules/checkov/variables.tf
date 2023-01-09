variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}
variable "paths" {
  default = ["/"]
}
variable "path" {
  default = "$${{ matrix.path }}"
}
