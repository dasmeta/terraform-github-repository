locals {
  template = var.template == null ? [] : [var.template]

  collab_admin    = { for i in coalesce(var.admin_collaborators, []) : i => "admin" }
  collab_push     = { for i in coalesce(var.push_collaborators, []) : i => "push" }
  collab_pull     = { for i in coalesce(var.pull_collaborators, []) : i => "pull" }
  collab_triage   = { for i in coalesce(var.triage_collaborators, []) : i => "triage" }
  collab_maintain = { for i in coalesce(var.maintain_collaborators, []) : i => "maintain" }

  collaborators = merge(
    local.collab_admin,
    local.collab_push,
    local.collab_pull,
    local.collab_triage,
    local.collab_maintain,
  )


  branch_protections = try([
    for b in var.branch_protections : merge({
      branch                          = null
      enforce_admins                  = null
      require_conversation_resolution = null
      require_signed_commits          = null
      required_status_checks          = {}
      required_pull_request_reviews   = {}
      restrictions                    = {}
    }, b)
  ], [])

  required_status_checks = [
    for b in local.branch_protections :
    length(keys(b.required_status_checks)) > 0 ? [
      merge(b.required_status_checks, {
        checks = concat(
          [
            "GitGuardian Security Checks:46505"
          ],
          var.semantic_release ? ["publish:15368"] : [],
          var.checkov || var.infracost || var.terraform_test || var.tflint ? ["terraform-validate (/):15368"] : [],
          var.tfsec ? ["terraform-tfsec:15368"] : [],
          var.pre_commit ? ["terraform-validate"] : []
        )
        include_admins = false
        strict         = true
    })] : []
  ]

  required_pull_request_reviews = [
    for b in local.branch_protections :
    length(keys(b.required_pull_request_reviews)) > 0 ? [
      merge({
        dismiss_stale_reviews           = true
        dismissal_users                 = []
        dismissal_teams                 = []
        require_code_owner_reviews      = null
        required_approving_review_count = null
    }, b.required_pull_request_reviews)] : []
  ]

  restrictions = [
    for b in local.branch_protections :
    length(keys(b.restrictions)) > 0 ? [
      merge({
        users = []
        teams = []
        apps  = []
    }, b.restrictions)] : []
  ]


  team_id_admin    = [for i in coalesce(var.admin_team_ids, []) : { team_id = i, permission = "admin" }]
  team_id_push     = [for i in coalesce(var.push_team_ids, []) : { team_id = i, permission = "push" }]
  team_id_pull     = [for i in coalesce(var.pull_team_ids, []) : { team_id = i, permission = "pull" }]
  team_id_triage   = [for i in coalesce(var.triage_team_ids, []) : { team_id = i, permission = "triage" }]
  team_id_maintain = [for i in coalesce(var.maintain_team_ids, []) : { team_id = i, permission = "maintain" }]

  team_ids = concat(
    local.team_id_admin,
    local.team_id_push,
    local.team_id_pull,
    local.team_id_triage,
    local.team_id_maintain,
  )


  team_admin    = [for i in coalesce(var.admin_teams, []) : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "admin" }]
  team_push     = [for i in coalesce(var.push_teams, []) : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "push" }]
  team_pull     = [for i in coalesce(var.pull_teams, []) : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "pull" }]
  team_triage   = [for i in coalesce(var.triage_teams, []) : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "triage" }]
  team_maintain = [for i in coalesce(var.maintain_teams, []) : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "maintain" }]

  teams = { for i in concat(
    local.team_admin,
    local.team_push,
    local.team_pull,
    local.team_triage,
    local.team_maintain,
  ) : i.slug => i }


  plaintext_secrets = { for name, value in coalesce(var.plaintext_secrets, {}) : name => { plaintext = value } }
  encrypted_secrets = { for name, value in coalesce(var.encrypted_secrets, {}) : name => { encrypted = value } }

  secrets = merge(local.plaintext_secrets, local.encrypted_secrets)


  repository_name = try(github_repository.repository[0].name, data.github_repository.existing_repo[0].name)
  full_name       = try(github_repository.repository[0].full_name, data.github_repository.existing_repo[0].full_name)
  branch_name     = var.branch_toPush != "" ? var.branch_toPush : var.default_branch != null ? var.default_branch : "main"
  commit_message  = var.commit_message
}

output "branch_protections" {
  value = local.branch_protections
}

output "required_status_checks" {
  value = local.required_status_checks
}
