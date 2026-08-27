# terraform-test

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
| <a name="input_actions_version"></a> [actions\_version](#input\_actions\_version) | Release of dasmeta/reusable-actions-workflows used by the generated<br/>workflow. Only consulted when mode is `test`. | `string` | `"4.4.0"` | no |
| <a name="input_aws-access-key-id"></a> [aws-access-key-id](#input\_aws-access-key-id) | n/a | `string` | `"${{ secrets.AWS_ACCESS_KEY_ID }}"` | no |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | n/a | `string` | `"${{ secrets.AWS_REGION}}"` | no |
| <a name="input_aws-secret-access-key"></a> [aws-secret-access-key](#input\_aws-secret-access-key) | n/a | `string` | `"${{ secrets.AWS_SECRET_ACCESS_KEY }}"` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | How each path is validated.<br/><br/>`test` runs the native `terraform test` suite through the shared action.<br/>It expects a tests/ directory containing *.tftest.hcl files.<br/><br/>`validate` runs `terraform init -backend=false && terraform validate`.<br/>Use it for repositories with no native test suite, and for modules whose<br/>providers are not AWS: this mode configures no credentials at all. | `string` | `"test"` | no |
| <a name="input_paths"></a> [paths](#input\_paths) | Module roots to validate. Each becomes one matrix leg reporting as<br/>`validate (<path>)`. The required context stays `terraform-validate`<br/>regardless of what is in this list. | `list(string)` | <pre>[<br/>  "./"<br/>]</pre> | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Terraform version used to validate. Must be >= 1.6 for the native test framework. | `string` | `"1.9.8"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_files"></a> [files](#output\_files) | The list of files created/commited by workflow module |
| <a name="output_workflow"></a> [workflow](#output\_workflow) | The rendered workflow body. Exposed so regression tests can assert against<br/>what is actually written to the repository rather than against the inputs,<br/>which is where the defects this module fixes lived. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
