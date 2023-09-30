resource "github_repository_file" "user-files" {
  for_each = { for file in coalesce(var.files, []) : file.remote_path => file }

  repository          = local.repository_name
  branch              = local.branch_name
  file                = each.value.remote_path
  content             = file("./${each.value.local_path}")
  commit_message      = var.files_commit_message
  overwrite_on_create = true


  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "branch_name_checker" {
  source = "../branch-name-checker"
  count  = coalesce(var.branch_name_checker, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  project_name    = var.project_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "pr_description_checker" {
  source = "../pr-description-checker"
  count  = coalesce(var.pr_description_checker, false) ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  project_name    = var.project_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "pr_title_checker" {
  source = "../pr-title-checker"
  count  = coalesce(var.pr_title_checker, false) ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  project_name    = var.project_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "pre_commit" {
  source = "../pre-commit"
  count  = coalesce(var.pre_commit, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "semantic_release" {
  source = "../semantic-release"
  count  = coalesce(var.semantic_release, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "checkov" {
  source = "../checkov"
  count  = coalesce(var.checkov, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  paths           = ["/"]

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "infracost" {
  source = "../infracost"
  count  = coalesce(var.infracost, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  paths           = ["/"]

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "terraform-test" {
  source = "../terraform-test"
  count  = coalesce(var.terraform_test, false) ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = local.repository_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "tflint" {
  source = "../tflint"
  count  = coalesce(var.tflint, false) ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  paths           = ["/"]

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "tfsec" {
  source = "../tfsec"
  count  = coalesce(var.tfsec, false) ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = local.repository_name

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "pr_terraform_plan" {
  source = "../terraform-plan-actions"
  count  = var.terraform_plan_and_apply != null ? 1 : 0

  branch_name      = var.branch_toPush
  repository_name  = local.repository_name
  path_to_module   = var.terraform_plan_and_apply.path_to_module
  module_variables = var.terraform_plan_and_apply.module_variables

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "terraform_apply" {
  source = "../terraform-apply-actions"
  count  = var.terraform_plan_and_apply != null ? 1 : 0

  branch_name      = var.branch_toPush
  repository_name  = local.repository_name
  path_to_module   = var.terraform_plan_and_apply.path_to_module
  module_variables = var.terraform_plan_and_apply.module_variables

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}

module "dependabot" {
  source = "../dependabot"
  count  = try(var.dependabot.enabled, false) ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = local.repository_name
  ecosystems      = try(var.dependabot.ecosystems, [])

  depends_on = [
    github_repository.repository,
    github_branch.branch,
    data.github_repository.existing_repo
  ]
}
