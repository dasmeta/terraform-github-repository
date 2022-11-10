variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "name" {
  default = ["fold1", "fold2"]
}

variable "path" {
  default = "$${{ matrix.path }}"
}
