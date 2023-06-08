# terraform-apply-actions

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.0 |

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
| <a name="input_module_variables"></a> [module\_variables](#input\_module\_variables) | We can use terraform apply GitHub action and set variables for modules | `map(string)` | `{}` | no |
| <a name="input_path_to_module"></a> [path\_to\_module](#input\_path\_to\_module) | Path to terraform configuration (Usually module) to run terraform-plan | `string` | `"./modules"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_files"></a> [files](#output\_files) | The list of files created/commited by workflow module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
