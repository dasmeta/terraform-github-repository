# Regression coverage for the rendered dependabot configuration.
#
# The assertions render the real template with the module's resolved updates and
# parse the result, rather than checking the locals alone. The bug this module
# exists to fix lived in the template's directories/directory branch, so a test
# that stops at the locals would still pass with that branch dead.
#
# The github provider is mocked: the config content is templatefile output over
# static inputs, so everything asserted here is known at plan time.

mock_provider "github" {}

variables {
  repository_name = "example-repo"
  branch_name     = "main"
}

run "default_preset_renders_module_directories" {
  command = plan

  assert {
    condition = yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })) == {
      version = 2
      updates = [
        {
          package-ecosystem = "terraform"
          directories       = ["/", "/modules/*"]
          schedule          = { interval = "weekly" }
        },
        {
          package-ecosystem = "github-actions"
          directory         = "/"
          schedule          = { interval = "weekly" }
        },
        {
          package-ecosystem = "npm"
          directory         = "/"
          schedule          = { interval = "weekly" }
        },
      ]
    }
    error_message = "The terraform-module preset must scan the module tree via directories, keep single-path entries on directory, and stay weekly."
  }
}

run "helm_chart_preset_renders_chart_directories" {
  command = plan

  variables {
    repo_type = "helm-chart"
  }

  assert {
    condition = [
      for update in yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })).updates :
      update["package-ecosystem"]
    ] == ["helm", "github-actions"]
    error_message = "The helm-chart preset must select helm and github-actions."
  }

  assert {
    condition     = yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })).updates[0].directories == ["/", "/charts/*"]
    error_message = "The helm-chart preset must scan the charts tree, not just the root."
  }
}

run "legacy_ecosystems_render_weekly_root_updates" {
  command = plan

  variables {
    ecosystems = ["terraform", "github-actions"]
  }

  assert {
    condition = yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })).updates == [
      {
        package-ecosystem = "terraform"
        directory         = "/"
        schedule          = { interval = "weekly" }
      },
      {
        package-ecosystem = "github-actions"
        directory         = "/"
        schedule          = { interval = "weekly" }
      },
    ]
    error_message = "The deprecated ecosystems input must still render one weekly root-directory entry per ecosystem."
  }
}

run "custom_updates_win_over_legacy_and_preset" {
  command = plan

  variables {
    repo_type  = "nodejs"
    ecosystems = ["terraform"]
    updates = [
      { package_ecosystem = "composer", interval = "monthly" },
    ]
  }

  assert {
    condition = yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })).updates == [
      {
        package-ecosystem = "composer"
        directory         = "/"
        schedule          = { interval = "monthly" }
      },
    ]
    error_message = "updates must take precedence over both ecosystems and the repo_type preset."
  }
}

run "disabled_entries_are_dropped" {
  command = plan

  variables {
    updates = [
      { package_ecosystem = "terraform", directories = ["/", "/modules/*"] },
      { package_ecosystem = "npm", enabled = false },
    ]
  }

  assert {
    condition = [
      for update in yamldecode(templatefile("${path.module}/templates/dependabot.yaml.tftpl", { updates = output.updates })).updates :
      update["package-ecosystem"]
    ] == ["terraform"]
    error_message = "An entry with enabled = false must stay documented in the input but be omitted from the rendered file."
  }
}

run "repo_type_none_writes_no_config_file" {
  command = plan

  variables {
    repo_type = "none"
  }

  assert {
    condition     = length(output.updates) == 0 && length(output.files) == 0 && length(module.this) == 0
    error_message = "repo_type = none must write no dependabot config; dependabot rejects a config whose updates key is empty."
  }
}

run "disabling_every_entry_writes_no_config_file" {
  command = plan

  variables {
    updates = [
      { package_ecosystem = "terraform", enabled = false },
    ]
  }

  assert {
    condition     = length(output.files) == 0 && length(module.this) == 0
    error_message = "Disabling every entry must write no dependabot config rather than an empty one."
  }
}

run "rejects_unknown_repo_type" {
  command = plan

  variables {
    repo_type = "rust"
  }

  expect_failures = [var.repo_type]
}
