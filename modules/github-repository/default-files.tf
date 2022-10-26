resource "github_repository_file" "user-files" {
  depends_on          = [github_branch.branch]
  for_each            = { for file in var.init_files : file.remote_path => file }
  repository          = local.repository_name
  branch              = local.branch_name
  file                = each.value.remote_path
  content             = file("./${each.value.local_path}")
  commit_message      = local.commit_message
  overwrite_on_create = true
}

module "branch_name_checker" {
  source = "./submodules/branch-name-checker"
  count  = var.branch_name_checker ? 1 : 0


  branch_name     = var.branch_toPush
  repository_name = github_repository.repository[0].name
  project_name    = var.project_name
}

module "pr_description_checker" {
  source = "./submodules/pr-description-checker"
  count  = var.pr_description_checker ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = github_repository.repository[0].name
  project_name    = var.project_name
}

module "pr_title_checker" {
  source = "./submodules/pr-title-checker"
  count  = var.pr_title_checker ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = github_repository.repository[0].name
  project_name    = var.project_name
}

module "pre_commit" {
  source = "./submodules/pre-commit"
  count  = var.pre_commit ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = github_repository.repository[0].name
}

module "semantic_release" {
  source = "./submodules/semantic-release"
  count  = var.semantic_release ? 1 : 0

  branch_name     = var.branch_toPush
  repository_name = github_repository.repository[0].name
}

module "pr_terraform_plan" {
  source = "./submodules/terraform-plan-actions"
  count  = var.terraform_apply != null ? 1 : 0

  branch_name      = var.branch_toPush
  repository_name  = github_repository.repository[0].name
  path_to_module   = var.terraform_apply.path_to_module
  module_variables = var.terraform_apply.module_variables
}


module "terraform_apply" {
  source = "./submodules/terraform-apply-actions"
  count  = var.terraform_apply != null ? 1 : 0

  branch_name      = var.branch_toPush
  repository_name  = github_repository.repository[0].name
  path_to_module   = var.terraform_apply.path_to_module
  module_variables = var.terraform_apply.module_variables
}
