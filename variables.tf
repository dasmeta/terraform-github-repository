variable "repositories" {
  type = list(object({
    name        = string
    description = optional(string)
    topics      = optional(list(string), ["terraform"])
    pages = optional(object({
      branch = string
      path   = optional(string, "/")
      cname  = optional(string, null)
    }), null)
  }))
  description = "description"
  # default     = "type"
}

//
variable "defaults" {
  description = "Default attributes for each repository"

  type = object({
    homepage_url           = optional(string, "www.example.com")
    license_template       = optional(string, "apache-2.0")
    topics                 = optional(list(string), ["terraform", "aws"])
    visibility             = optional(string, "public")
    has_issues             = optional(bool, true)
    has_projects           = optional(bool, true)
    has_wiki               = optional(bool, true)
    allow_merge_commit     = optional(bool, true)
    allow_rebase_merge     = optional(bool, true)
    allow_squash_merge     = optional(bool, true)
    allow_auto_merge       = optional(bool, false)
    delete_branch_on_merge = optional(bool, true)
    is_template            = optional(bool, null)
    has_downloads          = optional(bool, null)
    has_discussions        = optional(bool, null)
    auto_init              = optional(bool, true)
    gitignore_template     = optional(string, "Terraform")
    archived               = optional(bool, false)
    archive_on_destroy     = optional(bool, true)
    vulnerability_alerts   = optional(bool, true)
    template = optional(object({
      owner      = string
      repository = string
    }), null)
    admin_collaborators    = optional(list(string), [])
    push_collaborators     = optional(list(string), [])
    pull_collaborators     = optional(list(string), [])
    triage_collaborators   = optional(list(string), [])
    maintain_collaborators = optional(list(string), [])
    branches               = optional(list(string), ["DMVP-tf-init"])
    default_branch         = optional(string, "main")
    branch_protections = optional(any, [
      {
        branch                 = "main"
        enforce_admins         = true
        require_signed_commits = false
        required_status_checks = {
          checks = [
            "GitGuardian Security Checks:46505"
          ]
          include_admins = false
          strict         = true
        }
        required_pull_request_reviews = {
          dismiss_stale_reviews           = true
          require_code_owner_reviews      = true
          required_approving_review_count = 1
        }
      }
    ])
    admin_team_ids    = optional(list(string), [])
    push_team_ids     = optional(list(string), [])
    pull_team_ids     = optional(list(string), [])
    triage_team_ids   = optional(list(string), [])
    maintain_team_ids = optional(list(string), [])
    admin_teams       = optional(list(string), [])
    push_teams        = optional(list(string), [])
    pull_teams        = optional(list(string), [])
    triage_teams      = optional(list(string), [])
    maintain_teams    = optional(list(string), [])
    module_depends_on = optional(list(string), [])
    plaintext_secrets = optional(map(string), {})
    encrypted_secrets = optional(map(string), {})
    webhooks          = optional(any, [])
    commit_message    = optional(string, "Initial commit"),
    files = optional(list(object({
      remote_path = string
      local_path  = string
    })))
    files_commit_message = optional(string, "repo file create/change")
    project_name         = optional(string, "DMVP")
    secrets = optional(list(object({
      secret_name     = string
      plaintext_value = string
    })), [])
    branch_toPush          = optional(string, "DMVP-tf-init")
    create_repository      = optional(bool, true)
    branch_name_checker    = optional(bool, true)
    pr_description_checker = optional(bool, false)
    pr_title_checker       = optional(bool, true)
    pre_commit             = optional(bool, true)
    semantic_release       = optional(bool, true)
    checkov                = optional(bool, true)
    infracost              = optional(bool, false)
    terraform_test         = optional(bool, true)
    tflint                 = optional(bool, true)
    tfsec                  = optional(bool, true)
    terraform_plan_and_apply = optional(object({
      path_to_module   = string
      module_variables = map(string)
    }), null)
    dependabot = optional(object({
      enabled    = optional(bool, true)
      ecosystems = optional(list(string), ["github-actions", "terraform"]) # the list can be "terraform", "github-actions". Check for available values here https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file
      }), {
      enabled    = true
      ecosystems = ["github-actions", "terraform"]
    })
    pull_request = optional(object({
      create   = optional(bool, true)
      base_ref = optional(string, null) # if not set the default_branch will be used as target for PR
      title    = optional(string, "DMVP-0000: Initial PR for workflows changes")
      body     = optional(string, "Terraform generated PR for best practices changes")
      }), {
      create = true
      title  = "DMVP-0000: Initial PR"
    })
  })
  default = {}
}
