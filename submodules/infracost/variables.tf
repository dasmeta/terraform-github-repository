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

variable "secret" {
  default = "$${{secrets.INFRACOST_API_KEY}}"
}

variable "ref" {
  default = "'$${{ github.event.pull_request.base.ref }}'"
}

variable "path" {
  default = "$${{ matrix.path }}"
}

variable "token" {
  default = "$${{github.token}}"
}

variable "pr" {
  default = "$${{github.event.pull_request.number}}"
}
