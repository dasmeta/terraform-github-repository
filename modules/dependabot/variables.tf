variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "repo_type" {
  description = "Repository type used to pick the default set of dependabot updates. Currently only drives the dependabot configuration. Ignored when `updates` or `ecosystems` is set."
  type        = string
  default     = "terraform-module"

  validation {
    condition = contains([
      "terraform-module",
      "terraform-setup",
      "helm-chart",
      "nodejs",
      "php",
      "none",
    ], var.repo_type)
    error_message = "repo_type must be one of: terraform-module, terraform-setup, helm-chart, nodejs, php, none."
  }
}

variable "ecosystems" {
  description = "Deprecated, use `updates` instead. Simple list of ecosystems to monitor, each rendered against the repository root on the default interval. Ignored when `updates` is set."
  type        = list(string)
  default     = null
}

variable "updates" {
  description = "Dependabot update entries, overriding whatever `repo_type` would select. Set `enabled = false` on an entry to switch that ecosystem off without removing its configuration. Use `directories` for multiple paths or glob patterns such as `/modules/*`, or `directory` for a single path."
  type = list(object({
    package_ecosystem = string                     # dependabot ecosystem id, for example terraform, github-actions, npm, helm, composer
    directory         = optional(string, null)     # single path; mutually exclusive with directories
    directories       = optional(list(string))     # multiple paths, globs allowed; takes precedence over directory
    interval          = optional(string, "weekly") # daily, weekly or monthly
    enabled           = optional(bool, true)       # false keeps the entry documented but omits it from the rendered file
  }))
  default = null
}
