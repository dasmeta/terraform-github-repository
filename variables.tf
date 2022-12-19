variable "name" {
  description = "(Required) The name of the repository."
  type        = string
}

variable "description" {
  description = "(Optional) A description of the repository."
  type        = string
  default     = ""
}

variable "homepage_url" {
  description = "(Optional) The website of the repository."
  type        = string
  default     = null
}

variable "visibility" {
  description = "(Optional) Can be 'public', 'private' or 'internal'"
  type        = string
  default     = null
}

variable "has_issues" {
  description = "(Optional) Set to true to enable the GitHub Issues features on the repository"
  type        = bool
  default     = null
}

variable "has_projects" {
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository"
  type        = bool
  default     = null
}

variable "has_wiki" {
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository"
  type        = bool
  default     = null
}

variable "allow_merge_commit" {
  description = "(Optional) Set to false to disable merge commits on the repository"
  type        = bool
  default     = null
}

variable "allow_rebase_merge" {
  description = "(Optional) Set to true to enable rebase merges on the repository"
  type        = bool
  default     = null
}

variable "allow_squash_merge" {
  description = "(Optional) Set to true to enable squash merges on the repository"
  type        = bool
  default     = null
}

variable "allow_auto_merge" {
  description = "(Optional) Set to true to allow auto-merging pull requests on the repository"
  type        = bool
  default     = null
}

variable "delete_branch_on_merge" {
  description = "(Optional) Whether or not to delete the merged branch after merging a pull request"
  type        = bool
  default     = null
}

variable "is_template" {
  description = "(Optional) Whether or not to tell GitHub that this is a template repository"
  type        = bool
  default     = null
}

variable "has_downloads" {
  description = "(Optional) Set to true to enable the (deprecated) downloads features on the repository"
  type        = bool
  default     = null
}

variable "auto_init" {
  description = "(Optional) Wether or not to produce an initial commit in the repository"
  type        = bool
  default     = true
}

variable "gitignore_template" {
  description = "(Optional) Use the name of the template without the extension"
  type        = string
  default     = null
}

variable "license_template" {
  description = "(Optional) Use the name of the template without the extension"
  type        = string
  default     = null
}

variable "archived" {
  description = "(Optional) Specifies if the repository should be archived"
  type        = bool
  default     = false
}

variable "topics" {
  description = "(Optional) The list of topics of the repository"
  type        = list(string)
  default     = null
}

variable "archive_on_destroy" {
  type        = string
  description = "(Optional) Set to `false` to not archive the repository instead of deleting on destroy."
  default     = true
}

variable "vulnerability_alerts" {
  type        = bool
  description = "(Optional) Set to `false` to disable security alerts for vulnerable dependencies"
  default     = null
}

variable "template" {
  description = "(Optional) Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "pages" {
  description = "(Optional) The repository's GitHub Pages configuration. (Default: {})"
  # type = object({
  # branch = string
  # path   = string
  # cname  = string
  # })
  type    = any
  default = null
}

variable "admin_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them admin (full) permission."
  type        = list(string)
  default     = []
}

variable "push_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them push (read-write) permission."
  type        = list(string)
  default     = []
}

variable "pull_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them pull (read-only) permission."
  type        = list(string)
  default     = []
}

variable "triage_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them triage permission."
  type        = list(string)
  default     = []
}

variable "maintain_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them maintain permission."
  type        = list(string)
  default     = []
}

variable "branches" {
  description = "(Optional) A list of branches to be created in this repository."
  type        = list(string)
  default     = []
}

variable "default_branch" {
  description = "(Optional) The name of the default branch of the repository."
  type        = string
  default     = null
}

variable "branch_protections" {
  description = "Default is []."
  type        = any
  default     = null
}

variable "branch_protections_v3" {
  description = "(Optional) A list of branch protections to apply to the repository. Default is [] unless branch_protections is set."
  type        = any
  default     = null
  # Example:
  # branch_protections = [
  #   {
  #     branch                 = "main"
  #     enforce_admins         = true
  #     require_signed_commits = true
  #
  #     required_status_checks = {
  #       strict   = false
  #       contexts = ["ci/travis"]
  #     }
  #
  #     required_pull_request_reviews = {
  #       dismiss_stale_reviews           = true
  #       dismissal_users                 = ["user1", "user2"]
  #       dismissal_teams                 = ["team-slug-1", "team-slug-2"]
  #       require_code_owner_reviews      = true
  #       required_approving_review_count = 1
  #     }
  #
  #     restrictions = {
  #       users = ["user1"]
  #       teams = ["team-slug-1"]
  #     }
  #   }
  # ]
}


variable "admin_team_ids" {
  description = "(Optional) A list of teams (by id) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "push_team_ids" {
  description = "(Optional) A list of teams (by id) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "pull_team_ids" {
  description = "(Optional) A list of teams (by id) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "triage_team_ids" {
  description = "(Optional) A list of teams (by id) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "maintain_team_ids" {
  description = "(Optional) A list of teams (by id) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "admin_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

<<<<<<< HEAD
variable "paths" {
  type = list(any)
}

=======
>>>>>>> d4458c0836e258b5d5ef326397cdc63a0e18578f
variable "push_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "pull_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "triage_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "maintain_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) Define resources this module indirectly depends_on."
  default     = []
}

variable "plaintext_secrets" {
  description = "(Optional) Configuring actions secrets."
  type        = map(string)
  # plaintext_secrets = {
  #     "MY_SECRET" = "42"
  #     "OWN_TOKEN" = "12345"
  # }
  default = {}
}

variable "encrypted_secrets" {
  description = "(Optional) Configuring encrypted actions secrets."
  type        = map(string)
  # encrypted_secrets = {
  #     "MY_ENCRYPTED_SECRET" = "MTIzNDU="
  # }
  default = {}
}

variable "webhooks" {
  description = "(Optional) Configuring webhooks."
  type        = any
  default     = []
  # webhooks = [{
  #   active = false
  #   events = ["issues"]
  #   url          = "https://xxxx.xx/"
  #   content_type = "form"
  #   insecure_ssl = false
  # }]
}

variable "commit_message" {
  description = "Message to apply when default files are commited"
  type        = string
  default     = "initial commit"
}

variable "files" {
  description = "List of local and remote path binding objects, ability to push files from local to remote"
  type = list(object({
    remote_path = string
    local_path  = string
  }))
  default = []
}

variable "files_commit_message" {
  description = "Message to set on commit of above files"
  type        = string
  default     = "repo file create/change"
}

variable "project_name" {
  description = "Project name variable to configure in default-files"
  type        = string
  default     = "DMVP"
}

variable "secrets" {
  description = "Secret list to create in repository"
  type = list(object({
    secret_name     = string
    plaintext_value = string
  }))
  default = []
}

variable "branch_toPush" {
  description = "The Branch, where to push best practices"
  type        = string
  default     = ""
}

variable "create_repository" {
  description = "Whether create repository  or not"
  type        = bool
  default     = true
}


variable "branch_name_checker" {
  description = ""
  type        = bool
  default     = false
}

variable "pr_description_checker" {
  description = ""
  type        = bool
  default     = false
}

variable "pr_title_checker" {
  description = ""
  type        = bool
  default     = false
}

variable "pre_commit" {
  description = ""
  type        = bool
  default     = false
}

variable "semantic_release" {
  description = ""
  type        = bool
  default     = false
}
variable "checkov" {
  description = ""
  type        = bool
  default     = false
}

variable "infracost" {
  description = ""
  type        = bool
  default     = false
}

variable "terraform-test" {
  description = ""
  type        = bool
  default     = false
}

variable "tflint" {
  description = ""
  type        = bool
  default     = false
}

variable "tfsec" {
  description = ""
  type        = bool
  default     = false
}
variable "terraform_plan_and_apply" {
  description = ""
  type = object({
    path_to_module   = string
    module_variables = map(string)
  })
  default = null
}
