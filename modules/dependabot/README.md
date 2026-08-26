# tfsec

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.39.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../workflow-files-base | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_ecosystems"></a> [ecosystems](#input\_ecosystems) | Deprecated, use `updates` instead. Simple list of ecosystems to monitor, each rendered against the repository root on the default interval. Ignored when `updates` is set. | `list(string)` | `null` | no |
| <a name="input_repo_type"></a> [repo\_type](#input\_repo\_type) | Repository type used to pick the default set of dependabot updates. Currently only drives the dependabot configuration. Ignored when `updates` or `ecosystems` is set. | `string` | `"terraform-module"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |
| <a name="input_updates"></a> [updates](#input\_updates) | Dependabot update entries, overriding whatever `repo_type` would select. Set `enabled = false` on an entry to switch that ecosystem off without removing its configuration. Use `directories` for multiple paths or glob patterns such as `/modules/*`, or `directory` for a single path. | <pre>list(object({<br/>    package_ecosystem = string                     # dependabot ecosystem id, for example terraform, github-actions, npm, helm, composer<br/>    directory         = optional(string, null)     # single path; mutually exclusive with directories<br/>    directories       = optional(list(string))     # multiple paths, globs allowed; takes precedence over directory<br/>    interval          = optional(string, "weekly") # daily, weekly or monthly<br/>    enabled           = optional(bool, true)       # false keeps the entry documented but omits it from the rendered file<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_files"></a> [files](#output\_files) | The list of files created/commited by workflow module. Empty when no dependabot update is enabled, in which case no config file is written. |
| <a name="output_updates"></a> [updates](#output\_updates) | The resolved dependabot update entries written to the config file, after preset/legacy/custom selection and dropping disabled entries. Empty when no config file is written. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
