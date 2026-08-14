locals {
  # Every source below is normalized to the same shape so the conditional that
  # picks between them type-checks: `directories` is always a list (empty means
  # "use directory") and `directory` is always a string.

  # Default update sets per repository type. Only `terraform-module` is validated
  # against a working configuration in the wild (dasmeta/terraform-aws-rds); the
  # others are starting points and are expected to be refined as those repository
  # types are onboarded. Every ecosystem id used here is a value dependabot
  # accepts, see the options reference linked in variables.tf.
  presets = {
    # Provider and module versions at the root and in every submodule, the actions
    # the workflows call, and the npm tooling behind semantic-release/commitlint.
    terraform-module = [
      { package_ecosystem = "terraform", directory = "/", directories = ["/", "/modules/*"], interval = "weekly", enabled = true },
      { package_ecosystem = "github-actions", directory = "/", directories = [], interval = "weekly", enabled = true },
      { package_ecosystem = "npm", directory = "/", directories = [], interval = "weekly", enabled = true },
    ]

    # Root configuration repositories: no submodule tree to walk.
    terraform-setup = [
      { package_ecosystem = "terraform", directory = "/", directories = [], interval = "weekly", enabled = true },
      { package_ecosystem = "github-actions", directory = "/", directories = [], interval = "weekly", enabled = true },
      { package_ecosystem = "npm", directory = "/", directories = [], interval = "weekly", enabled = true },
    ]

    # Chart dependencies at the root and under a charts tree, plus workflow actions.
    helm-chart = [
      { package_ecosystem = "helm", directory = "/", directories = ["/", "/charts/*"], interval = "weekly", enabled = true },
      { package_ecosystem = "github-actions", directory = "/", directories = [], interval = "weekly", enabled = true },
    ]

    nodejs = [
      { package_ecosystem = "npm", directory = "/", directories = [], interval = "weekly", enabled = true },
      { package_ecosystem = "github-actions", directory = "/", directories = [], interval = "weekly", enabled = true },
    ]

    php = [
      { package_ecosystem = "composer", directory = "/", directories = [], interval = "weekly", enabled = true },
      { package_ecosystem = "github-actions", directory = "/", directories = [], interval = "weekly", enabled = true },
    ]

    # Nothing selected by type; the caller is expected to supply `updates`.
    none = []
  }

  preset_updates = tolist(local.presets[var.repo_type])

  # Legacy `ecosystems` input, kept so existing callers keep working. Each entry
  # becomes a weekly root-directory update.
  legacy_updates = tolist([
    for ecosystem in coalesce(var.ecosystems, []) : {
      package_ecosystem = ecosystem
      directory         = "/"
      directories       = []
      interval          = "weekly"
      enabled           = true
    }
  ])

  custom_updates = tolist([
    for update in coalesce(var.updates, []) : {
      package_ecosystem = update.package_ecosystem
      directory         = coalesce(update.directory, "/")
      directories       = coalesce(update.directories, [])
      interval          = coalesce(update.interval, "weekly")
      enabled           = coalesce(update.enabled, true)
    }
  ])

  resolved_updates = (
    var.updates != null ? local.custom_updates :
    var.ecosystems != null ? local.legacy_updates :
    local.preset_updates
  )

  # Drop entries the caller switched off.
  enabled_updates = [
    for update in local.resolved_updates : {
      package_ecosystem = update.package_ecosystem
      directory         = update.directory
      directories       = update.directories
      interval          = update.interval
    }
    if update.enabled
  ]
}

# Skip the file entirely when nothing is enabled. Dependabot rejects a config
# whose `updates` key has no entries, so writing an empty one is worse than
# writing none at all. This is reachable via repo_type = "none" with no
# `updates` supplied, or by disabling every entry.
module "this" {
  source = "../workflow-files-base"
  count  = length(local.enabled_updates) > 0 ? 1 : 0

  repository = var.repository_name
  branch     = var.branch_name
  variables  = { updates = local.enabled_updates }
  files = [
    {
      remote_path = ".github/dependabot.yaml"
      local_path  = "${path.module}/templates/dependabot.yaml.tftpl"
    }
  ]
}
