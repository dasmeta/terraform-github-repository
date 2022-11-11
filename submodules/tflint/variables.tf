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

variable "aws-region" {
  default = "$${{ secrets.AWS_REGION}}"
}

variable "aws-access-key-id" {
  default = "$${{ secrets.AWS_ACCESS_KEY_ID }}"
}

variable "aws-secret-access-key" {
  default = "$${{ secrets.AWS_SECRET_ACCESS_KEY }}"
}

variable "path" {
  default = "$${{ matrix.path }}"
}

variable "repo-token" {
  default = "$${{ secrets.GITHUB_TOKEN }}"
}
