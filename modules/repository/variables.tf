variable "name" {
  description = "(Required) The name of the github repository without organization/owner prefix. The owner determined on github provider block"
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
  default     = "public"
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

variable "has_discussions" {
  description = "(Optional) Set to true to enable the Discussions features on the repository"
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
  default     = ["DMVP-tf-init"]
}

variable "default_branch" {
  description = "(Optional) The name of the default branch of the repository."
  type        = string
  default     = "main"
}

variable "branch_protections" {
  description = "(Optional) A list of branch protections to apply to the repository."
  type        = any
  default = [
    {
      branch                 = "main"
      enforce_admins         = true
      require_signed_commits = false
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }
      required_status_checks = {
        checks = [
          "GitGuardian Security Checks:46505"
        ]
        include_admins = false
        strict         = true
      }
    }
  ]
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
  description = "The Branch, where to push best practices: the default DMVP-tf-init branch name is used by default to push files for best practices"
  type        = string
  default     = "DMVP-tf-init"
}

variable "create_repository" {
  description = "Whether to create repository or not and just link existing one"
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
  default     = true
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

variable "terraform_test" {
  description = "Master switch for the generated Terraform validation workflow"
  type        = bool
  default     = false
}

variable "terraform_test_configs" {
  description = <<-EOT
    Shape of the generated Terraform validation workflow. Left unset it keeps
    the previous behaviour: native `terraform test` at the repository root.

    The required status context is always `terraform-validate`, whatever
    `paths` contains. Individual paths report as `validate (<path>)` for
    visibility only, so branch protection does not need editing when the path
    list changes.
  EOT
  type = object({
    paths             = optional(list(string), ["./"]) # module roots to validate, one matrix leg each
    mode              = optional(string, "test")       # test = native terraform test; validate = init -backend=false && validate, no credentials
    terraform_version = optional(string, "1.9.8")      # >= 1.6 required for the native test framework
    actions_version   = optional(string, "4.4.0")      # dasmeta/reusable-actions-workflows release, only used by test mode
  })
  default = null
}

variable "pre_commit_configs" {
  description = <<-EOT
    Versions used by the generated pre-commit setup. Left unset it uses the
    defaults, which are the supported combination.

    Pin `terraform_docs_version` to the same release locally: generated
    documentation differs between terraform-docs versions, so a mismatch makes
    every README look out of date on somebody's machine.
  EOT
  type = object({
    actions_version              = optional(string, "4.4.0")    # >= 4.4.0, earlier pre-commit action releases could not fail
    terraform_docs_version       = optional(string, "0.20.0")   # matches what managed repositories have committed
    pre_commit_terraform_version = optional(string, "v1.109.0") # >= v1.93 migrates legacy docs markers in place
  })
  default = null
}

variable "tflint" {
  description = ""
  type        = bool
  default     = false
}

variable "trivy" {
  description = "Whether to add the Trivy security scan workflow, replaces the retired tfsec one"
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

variable "dependabot" {
  type = object({
    enabled    = optional(bool, false)                # master switch for the whole dependabot config file
    repo_type  = optional(string, "terraform-module") # picks the default update set: terraform-module, terraform-setup, helm-chart, nodejs, php, none
    ecosystems = optional(list(string), null)         # deprecated, use `updates`; each entry becomes a weekly root-directory update
    updates = optional(list(object({                  # per-ecosystem configuration; overrides whatever repo_type selects
      package_ecosystem = string                      # dependabot ecosystem id, see https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file
      directory         = optional(string, null)      # single path to scan; mutually exclusive with directories
      directories       = optional(list(string))      # several paths, globs allowed such as /modules/*; takes precedence over directory
      interval          = optional(string, "weekly")  # daily, weekly or monthly
      enabled           = optional(bool, true)        # set false to switch this ecosystem off while keeping it documented
    })), null)
  })
  default     = null
  description = "Allows to enable/configure dependabot for github repository"
}

variable "pull_request" {
  type = object({
    create   = optional(bool, false)
    base_ref = optional(string, null) # if not set the default_branch will be used as target for PR
    title    = optional(string, "Workflows changes")
    body     = optional(string, "Terraform generated PR for best practices changes")
  })
  default = {
    create = true
    title  = "feat(DMVP): Initial PR"
  }
  description = "Whether to create poll request"
}

variable "enable_github_actions" {
  type        = string
  description = "The permissions policy that controls the actions that are allowed to run. Can be one of: all, local_only, or selected."
  default     = "all"
}

variable "allowed_github_actions_config" {
  type = object({
    github_owned_allowed = bool
    patterns_allowed     = optional(list(string), ["actions/checkout@*"])
    verified_allowed     = optional(bool, true)
  })
  description = "description"
  default     = null
}
