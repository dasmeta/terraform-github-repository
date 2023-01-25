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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_branch_name_checker"></a> [branch\_name\_checker](#module\_branch\_name\_checker) | ./modules/branch-name-checker | n/a |
| <a name="module_checkov"></a> [checkov](#module\_checkov) | ./modules/checkov | n/a |
| <a name="module_infracost"></a> [infracost](#module\_infracost) | ./modules/infracost | n/a |
| <a name="module_pr_description_checker"></a> [pr\_description\_checker](#module\_pr\_description\_checker) | ./modules/pr-description-checker | n/a |
| <a name="module_pr_terraform_plan"></a> [pr\_terraform\_plan](#module\_pr\_terraform\_plan) | ./modules/terraform-plan-actions | n/a |
| <a name="module_pr_title_checker"></a> [pr\_title\_checker](#module\_pr\_title\_checker) | ./modules/pr-title-checker | n/a |
| <a name="module_pre_commit"></a> [pre\_commit](#module\_pre\_commit) | ./modules/pre-commit | n/a |
| <a name="module_semantic_release"></a> [semantic\_release](#module\_semantic\_release) | ./modules/semantic-release | n/a |
| <a name="module_terraform-test"></a> [terraform-test](#module\_terraform-test) | ./modules/terraform-test | n/a |
| <a name="module_terraform_apply"></a> [terraform\_apply](#module\_terraform\_apply) | ./modules/terraform-apply-actions | n/a |
| <a name="module_tflint"></a> [tflint](#module\_tflint) | ./modules/tflint | n/a |
| <a name="module_tfsec"></a> [tfsec](#module\_tfsec) | ./modules/tfsec | n/a |

## Resources

| Name | Type |
|------|------|
| [github_actions_secret.example_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.repository_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_branch.branch](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection_v3.branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection_v3) | resource |
| [github_repository.repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.collaborator](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_file.user-files](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_webhook.repository_webhook](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [github_team_repository.team_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team_repository.team_repository_by_slug](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_repository.existing_repo](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_collaborators"></a> [admin\_collaborators](#input\_admin\_collaborators) | (Optional) A list of users to add as collaborators granting them admin (full) permission. | `list(string)` | `[]` | no |
| <a name="input_admin_team_ids"></a> [admin\_team\_ids](#input\_admin\_team\_ids) | (Optional) A list of teams (by id) to grant admin (full) permission to. | `list(string)` | `[]` | no |
| <a name="input_admin_teams"></a> [admin\_teams](#input\_admin\_teams) | (Optional) A list of teams (by name/slug) to grant admin (full) permission to. | `list(string)` | `[]` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | (Optional) Set to true to allow auto-merging pull requests on the repository | `bool` | `null` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | (Optional) Set to false to disable merge commits on the repository | `bool` | `null` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | (Optional) Set to true to enable rebase merges on the repository | `bool` | `null` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | (Optional) Set to true to enable squash merges on the repository | `bool` | `null` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | (Optional) Set to `false` to not archive the repository instead of deleting on destroy. | `string` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | (Optional) Specifies if the repository should be archived | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | (Optional) Wether or not to produce an initial commit in the repository | `bool` | `true` | no |
| <a name="input_branch_name_checker"></a> [branch\_name\_checker](#input\_branch\_name\_checker) | n/a | `bool` | `false` | no |
| <a name="input_branch_protections"></a> [branch\_protections](#input\_branch\_protections) | Default is []. | `any` | `null` | no |
| <a name="input_branch_protections_v3"></a> [branch\_protections\_v3](#input\_branch\_protections\_v3) | (Optional) A list of branch protections to apply to the repository. Default is [] unless branch\_protections is set. | `any` | `null` | no |
| <a name="input_branch_toPush"></a> [branch\_toPush](#input\_branch\_toPush) | The Branch, where to push best practices | `string` | `""` | no |
| <a name="input_branches"></a> [branches](#input\_branches) | (Optional) A list of branches to be created in this repository. | `list(string)` | `[]` | no |
| <a name="input_checkov"></a> [checkov](#input\_checkov) | n/a | `bool` | `false` | no |
| <a name="input_commit_message"></a> [commit\_message](#input\_commit\_message) | Message to apply when default files are commited | `string` | `"initial commit"` | no |
| <a name="input_create_repository"></a> [create\_repository](#input\_create\_repository) | Whether to create repository or not and just link existing one | `bool` | `true` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | (Optional) The name of the default branch of the repository. | `string` | `null` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | (Optional) Whether or not to delete the merged branch after merging a pull request | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the repository. | `string` | `""` | no |
| <a name="input_encrypted_secrets"></a> [encrypted\_secrets](#input\_encrypted\_secrets) | (Optional) Configuring encrypted actions secrets. | `map(string)` | `{}` | no |
| <a name="input_files"></a> [files](#input\_files) | List of local and remote path binding objects, ability to push files from local to remote | <pre>list(object({<br>    remote_path = string<br>    local_path  = string<br>  }))</pre> | `[]` | no |
| <a name="input_files_commit_message"></a> [files\_commit\_message](#input\_files\_commit\_message) | Message to set on commit of above files | `string` | `"repo file create/change"` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | (Optional) Use the name of the template without the extension | `string` | `null` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | (Optional) Set to true to enable the (deprecated) downloads features on the repository | `bool` | `null` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | (Optional) Set to true to enable the GitHub Issues features on the repository | `bool` | `null` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | (Optional) Set to true to enable the GitHub Projects features on the repository | `bool` | `null` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | (Optional) Set to true to enable the GitHub Wiki features on the repository | `bool` | `null` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | (Optional) The website of the repository. | `string` | `null` | no |
| <a name="input_infracost"></a> [infracost](#input\_infracost) | n/a | `bool` | `false` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | (Optional) Whether or not to tell GitHub that this is a template repository | `bool` | `null` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | (Optional) Use the name of the template without the extension | `string` | `null` | no |
| <a name="input_maintain_collaborators"></a> [maintain\_collaborators](#input\_maintain\_collaborators) | (Optional) A list of users to add as collaborators granting them maintain permission. | `list(string)` | `[]` | no |
| <a name="input_maintain_team_ids"></a> [maintain\_team\_ids](#input\_maintain\_team\_ids) | (Optional) A list of teams (by id) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_maintain_teams"></a> [maintain\_teams](#input\_maintain\_teams) | (Optional) A list of teams (by name/slug) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | (Optional) Define resources this module indirectly depends\_on. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the github repository without organization/owner prefix. The owner determined on github provider block | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | (Optional) The repository's GitHub Pages configuration. (Default: {}) | `any` | `null` | no |
| <a name="input_plaintext_secrets"></a> [plaintext\_secrets](#input\_plaintext\_secrets) | (Optional) Configuring actions secrets. | `map(string)` | `{}` | no |
| <a name="input_pr_description_checker"></a> [pr\_description\_checker](#input\_pr\_description\_checker) | n/a | `bool` | `false` | no |
| <a name="input_pr_title_checker"></a> [pr\_title\_checker](#input\_pr\_title\_checker) | n/a | `bool` | `false` | no |
| <a name="input_pre_commit"></a> [pre\_commit](#input\_pre\_commit) | n/a | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name variable to configure in default-files | `string` | `"DMVP"` | no |
| <a name="input_pull_collaborators"></a> [pull\_collaborators](#input\_pull\_collaborators) | (Optional) A list of users to add as collaborators granting them pull (read-only) permission. | `list(string)` | `[]` | no |
| <a name="input_pull_team_ids"></a> [pull\_team\_ids](#input\_pull\_team\_ids) | (Optional) A list of teams (by id) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_pull_teams"></a> [pull\_teams](#input\_pull\_teams) | (Optional) A list of teams (by name/slug) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_collaborators"></a> [push\_collaborators](#input\_push\_collaborators) | (Optional) A list of users to add as collaborators granting them push (read-write) permission. | `list(string)` | `[]` | no |
| <a name="input_push_team_ids"></a> [push\_team\_ids](#input\_push\_team\_ids) | (Optional) A list of teams (by id) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_teams"></a> [push\_teams](#input\_push\_teams) | (Optional) A list of teams (by name/slug) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secret list to create in repository | <pre>list(object({<br>    secret_name     = string<br>    plaintext_value = string<br>  }))</pre> | `[]` | no |
| <a name="input_semantic_release"></a> [semantic\_release](#input\_semantic\_release) | n/a | `bool` | `false` | no |
| <a name="input_template"></a> [template](#input\_template) | (Optional) Template repository to use. (Default: {}) | <pre>object({<br>    owner      = string<br>    repository = string<br>  })</pre> | `null` | no |
| <a name="input_terraform-test"></a> [terraform-test](#input\_terraform-test) | n/a | `bool` | `false` | no |
| <a name="input_terraform_plan_and_apply"></a> [terraform\_plan\_and\_apply](#input\_terraform\_plan\_and\_apply) | n/a | <pre>object({<br>    path_to_module   = string<br>    module_variables = map(string)<br>  })</pre> | `null` | no |
| <a name="input_tflint"></a> [tflint](#input\_tflint) | n/a | `bool` | `false` | no |
| <a name="input_tfsec"></a> [tfsec](#input\_tfsec) | n/a | `bool` | `false` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Optional) The list of topics of the repository | `list(string)` | `null` | no |
| <a name="input_triage_collaborators"></a> [triage\_collaborators](#input\_triage\_collaborators) | (Optional) A list of users to add as collaborators granting them triage permission. | `list(string)` | `[]` | no |
| <a name="input_triage_team_ids"></a> [triage\_team\_ids](#input\_triage\_team\_ids) | (Optional) A list of teams (by id) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_triage_teams"></a> [triage\_teams](#input\_triage\_teams) | (Optional) A list of teams (by name/slug) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | (Optional) Can be 'public', 'private' or 'internal' | `string` | `null` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | (Optional) Set to `false` to disable security alerts for vulnerable dependencies | `bool` | `null` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | (Optional) Configuring webhooks. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | The name of git repo with org.owner in form '{owner}/{name}' |
| <a name="output_name"></a> [name](#output\_name) | The name of git repo without org/owner |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
