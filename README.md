## How to
This module allows you to create and manage repositories within your GitHub organization or personal account also allows you to manage your GitHub organization's members and teams easily.


## the following sample is for adding providers for this module

```terraform
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = ""  //  personal access token for your account, better to set env variable GITHUB_TOKEN
  owner = ""  // name of the organization/owner of repo
}

```

## Minimal requirements
```terraform
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.1"

  name           = "my-test-repo"
  default_branch = "main"
  visibility     = "private"
}
```

## Enable Pipilines
```terraform
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.1"

  name             = "Test"
  description      = "Terraform test"
  default_branch   = "main"
  visibility       = "private"
  pre_commit       = true
  branch_toPush    = "main"
  semantic_release = true
  checkov          = true
  infracost        = true
  terraform-test   = true
  tflint           = true
  tfsec            = true
}
```

## Maximal example of usage
```terraform
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.1"

  name                   = "test-repository"
  description            = "Testing env for terraform github repo"
  default_branch         = "main"
  visibility             = "public"
  license_template       = "apache-2.0"
  gitignore_template     = "Terraform"
  allow_auto_merge       = false
  allow_rebase_merge     = true
  delete_branch_on_merge = false
  auto_init              = true
  gitignore_template     = "*.tfvars"
  admin_collaborators    = ["user1", "user2"]
  push_collaborators     = ["user1"]
  pull_collaborators     = ["user1"]
  branch_protections_v3 = [
    {
      branch                 = "main"
      enforce_admins         = true
      require_signed_commits = true

      required_status_checks = {
        strict   = false
        contexts = ["ci"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        dismissal_users                 = ["user1", "user2"]
        dismissal_teams                 = ["team-slug-1", "team-slug-2"]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        users = ["user1"]
        teams = ["team-slug-1"]
      }
    }
  ]

  admin_teams = ["user1"]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ./modules/repository | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_defaults"></a> [defaults](#input\_defaults) | Default attributes for each repository | <pre>object({<br>    homepage_url           = optional(string, "www.example.com")<br>    license_template       = optional(string, "apache-2.0")<br>    topics                 = optional(list(string), ["terraform", "aws"])<br>    visibility             = optional(string, "public")<br>    has_issues             = optional(bool, true)<br>    has_projects           = optional(bool, true)<br>    has_wiki               = optional(bool, true)<br>    allow_merge_commit     = optional(bool, true)<br>    allow_rebase_merge     = optional(bool, true)<br>    allow_squash_merge     = optional(bool, true)<br>    allow_auto_merge       = optional(bool, false)<br>    delete_branch_on_merge = optional(bool, false)<br>    is_template            = optional(bool, null)<br>    has_downloads          = optional(bool, null)<br>    has_discussions        = optional(bool, null)<br>    auto_init              = optional(bool, true)<br>    gitignore_template     = optional(bool, true)<br>    archived               = optional(bool, false)<br>    archive_on_destroy     = optional(bool, true)<br>    vulnerability_alerts   = optional(bool, true)<br>    template = optional(object({<br>      owner      = string<br>      repository = string<br>    }), null)<br>    pages = optional(object({<br>      branch = string<br>      path   = string<br>      cname  = string<br>    }), null)<br>    admin_collaborators    = optional(list(string), [])<br>    push_collaborators     = optional(list(string), [])<br>    pull_collaborators     = optional(list(string), [])<br>    triage_collaborators   = optional(list(string), [])<br>    maintain_collaborators = optional(list(string), [])<br>    branches               = optional(list(string), ["DMVP-tf-init"])<br>    default_branch         = optional(string, "main")<br>    branch_protections = optional(any, [<br>      {<br>        branch                 = "main"<br>        enforce_admins         = true<br>        require_signed_commits = false<br>        required_status_checks = {<br>          checks = [<br>            "GitGuardian Security Checks:46505"<br>          ]<br>          include_admins = false<br>          strict         = true<br>        }<br>        required_pull_request_reviews = {<br>          dismiss_stale_reviews           = true<br>          require_code_owner_reviews      = true<br>          required_approving_review_count = 1<br>        }<br>      }<br>    ])<br>    admin_team_ids    = optional(list(string), [])<br>    push_team_ids     = optional(list(string), [])<br>    pull_team_ids     = optional(list(string), [])<br>    triage_team_ids   = optional(list(string), [])<br>    maintain_team_ids = optional(list(string), [])<br>    admin_teams       = optional(list(string), [])<br>    push_teams        = optional(list(string), [])<br>    pull_teams        = optional(list(string), [])<br>    triage_teams      = optional(list(string), [])<br>    maintain_teams    = optional(list(string), [])<br>    module_depends_on = optional(list(string), [])<br>    plaintext_secrets = optional(map(string), {})<br>    encrypted_secrets = optional(map(string), {})<br>    webhooks          = optional(any, [])<br>    commit_message    = optional(string, "Initial commit"),<br>    files = optional(list(object({<br>      remote_path = string<br>      local_path  = string<br>    })))<br>    files_commit_message = optional(string, "repo file create/change")<br>    project_name         = optional(string, "DMVP")<br>    secrets = optional(list(object({<br>      secret_name     = string<br>      plaintext_value = string<br>    })), [])<br>    branch_toPush          = optional(string, "DMVP-tf-init")<br>    create_repository      = optional(bool, true)<br>    branch_name_checker    = optional(bool, true)<br>    pr_description_checker = optional(bool, false)<br>    pr_title_checker       = optional(bool, true)<br>    pre_commit             = optional(bool, true)<br>    semantic_release       = optional(bool, true)<br>    checkov                = optional(bool, true)<br>    infracost              = optional(bool, true)<br>    terraform_test         = optional(bool, true)<br>    tflint                 = optional(bool, true)<br>    tfsec                  = optional(bool, true)<br>    terraform_plan_and_apply = optional(object({<br>      path_to_module   = string<br>      module_variables = map(string)<br>    }), null)<br>    dependabot = optional(object({<br>      enabled    = optional(bool, true)<br>      ecosystems = optional(list(string), ["github-actions", "terraform"]) # the list can be "terraform", "github-actions". Check for available values here https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file<br>      }), {<br>      enabled    = true<br>      ecosystems = ["github-actions", "terraform"]<br>    })<br>    pull_request = optional(object({<br>      create   = optional(bool, true)<br>      base_ref = optional(string, null) # if not set the default_branch will be used as target for PR<br>      title    = optional(string, "DMVP-0000: Initial PR for workflows changes")<br>      body     = optional(string, "Terraform generated PR for best practices changes")<br>      }), {<br>      create = true<br>      title  = "DMVP-0000: Initial PR"<br>    })<br>  })</pre> | `{}` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | description | <pre>list(object({<br>    name        = string<br>    description = optional(string)<br>    topics      = optional(list(string), ["terraform"])<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
