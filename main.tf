locals {
  merged_repositories = [
    for repo in var.repositories :
    merge(
      var.defaults,
      {
        "description" = repo.description,
        "name"        = repo.name,
        "topics"      = setunion(var.defaults.topics, repo.topics)
      }
    )
  ]
  repositories_map = { for repo in local.merged_repositories : repo.name => repo }
}

module "this" {
  source = "./modules/repository"

  for_each = local.repositories_map

  name                     = each.value.name
  description              = each.value.description
  topics                   = each.value.topics
  license_template         = each.value.license_template
  homepage_url             = each.value.homepage_url
  visibility               = each.value.visibility
  has_issues               = each.value.has_issues
  has_projects             = each.value.has_projects
  has_wiki                 = each.value.has_wiki
  allow_merge_commit       = each.value.allow_merge_commit
  allow_rebase_merge       = each.value.allow_rebase_merge
  allow_squash_merge       = each.value.allow_squash_merge
  allow_auto_merge         = each.value.allow_auto_merge
  delete_branch_on_merge   = each.value.delete_branch_on_merge
  is_template              = each.value.is_template
  has_downloads            = each.value.has_downloads
  has_discussions          = each.value.has_discussions
  auto_init                = each.value.auto_init
  gitignore_template       = each.value.gitignore_template
  archived                 = each.value.archived
  archive_on_destroy       = each.value.archive_on_destroy
  vulnerability_alerts     = each.value.vulnerability_alerts
  template                 = each.value.template
  pages                    = each.value.pages
  admin_collaborators      = each.value.admin_collaborators
  push_collaborators       = each.value.push_collaborators
  pull_collaborators       = each.value.pull_collaborators
  triage_collaborators     = each.value.triage_collaborators
  maintain_collaborators   = each.value.maintain_collaborators
  branches                 = each.value.branches
  default_branch           = each.value.default_branch
  branch_protections       = each.value.branch_protections
  admin_team_ids           = each.value.admin_team_ids
  push_team_ids            = each.value.push_team_ids
  pull_team_ids            = each.value.pull_team_ids
  triage_team_ids          = each.value.triage_team_ids
  maintain_team_ids        = each.value.maintain_team_ids
  admin_teams              = each.value.admin_teams
  push_teams               = each.value.push_teams
  pull_teams               = each.value.pull_teams
  triage_teams             = each.value.triage_teams
  maintain_teams           = each.value.maintain_teams
  module_depends_on        = each.value.module_depends_on
  plaintext_secrets        = each.value.plaintext_secrets
  encrypted_secrets        = each.value.encrypted_secrets
  webhooks                 = each.value.webhooks
  commit_message           = each.value.commit_message
  files                    = each.value.files
  files_commit_message     = each.value.files_commit_message
  project_name             = each.value.project_name
  secrets                  = each.value.secrets
  branch_toPush            = each.value.branch_toPush
  create_repository        = each.value.create_repository
  branch_name_checker      = each.value.branch_name_checker
  pr_description_checker   = each.value.pr_description_checker
  pr_title_checker         = each.value.pr_title_checker
  pre_commit               = each.value.pre_commit
  semantic_release         = each.value.semantic_release
  checkov                  = each.value.checkov
  infracost                = each.value.infracost
  terraform_test           = each.value.terraform_test
  tflint                   = each.value.tflint
  tfsec                    = each.value.tfsec
  terraform_plan_and_apply = each.value.terraform_plan_and_apply
  dependabot               = each.value.dependabot
  pull_request             = each.value.pull_request
}
