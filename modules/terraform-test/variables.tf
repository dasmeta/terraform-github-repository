variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "paths" {
  description = <<-EOT
    Module roots to validate. Each becomes one matrix leg reporting as
    `validate (<path>)`. The required context stays `terraform-validate`
    regardless of what is in this list.
  EOT
  type        = list(string)
  default     = ["./"]
}

variable "mode" {
  description = <<-EOT
    How each path is validated.

    `test` runs the native `terraform test` suite through the shared action.
    It expects a tests/ directory containing *.tftest.hcl files.

    `validate` runs `terraform init -backend=false && terraform validate`.
    Use it for repositories with no native test suite, and for modules whose
    providers are not AWS: this mode configures no credentials at all.
  EOT
  type        = string
  default     = "test"

  validation {
    condition     = contains(["test", "validate"], var.mode)
    error_message = "mode must be one of: test, validate."
  }
}

variable "terraform_version" {
  description = "Terraform version used to validate. Must be >= 1.6 for the native test framework."
  type        = string
  default     = "1.9.8"
}

variable "actions_version" {
  description = <<-EOT
    Release of dasmeta/reusable-actions-workflows used by the generated
    workflow. Only consulted when mode is `test`.
  EOT
  type        = string
  default     = "4.4.0"
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
