# terraform-plan-actions

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_file.githooks-default-files](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_module_variables"></a> [module\_variables](#input\_module\_variables) | We can use terraform apply GitHub action and set variables for modules | `map(string)` | `{}` | no |
| <a name="input_path_to_module"></a> [path\_to\_module](#input\_path\_to\_module) | Path to terraform configuration (Usually module) to run terraform-plan | `string` | `"./modules"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_commit_message"></a> [commit\_message](#output\_commit\_message) | n/a |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
