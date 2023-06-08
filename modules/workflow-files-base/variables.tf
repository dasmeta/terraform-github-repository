variable "repository" {
  type        = string
  description = "Repository name to apply actions"
}

variable "branch" {
  type        = string
  description = "Branch name to apply actions"
}

variable "files" {
  type = list(object({
    remote_path = string # remote path of file to commit/push
    local_path  = string # local path to template file to generate file content
  }))
  default     = []
  description = "The list of files to commit/push"
}

variable "variables" {
  type        = any
  default     = {}
  description = "The map of data to pass to workflow template files"
}

variable "commit_message_prefix" {
  type        = string
  default     = "Change by terraform in repo workflow config"
  description = "The prefix for commit message"
}

variable "overwrite_on_create" {
  type        = bool
  default     = true
  description = "Whether to override if file already exists"
}
