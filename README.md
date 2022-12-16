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
