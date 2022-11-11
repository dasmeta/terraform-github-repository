# tflint

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
| <a name="input_aws-access-key-id"></a> [aws-access-key-id](#input\_aws-access-key-id) | n/a | `string` | `"${{ secrets.AWS_ACCESS_KEY_ID }}"` | no |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | n/a | `string` | `"${{ secrets.AWS_REGION}}"` | no |
| <a name="input_aws-secret-access-key"></a> [aws-secret-access-key](#input\_aws-secret-access-key) | n/a | `string` | `"${{ secrets.AWS_SECRET_ACCESS_KEY }}"` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `list` | <pre>[<br>  "fold1",<br>  "fold2"<br>]</pre> | no |
| <a name="input_path"></a> [path](#input\_path) | n/a | `string` | `"${{ matrix.path }}"` | no |
| <a name="input_repo-token"></a> [repo-token](#input\_repo-token) | n/a | `string` | `"${{ secrets.GITHUB_TOKEN }}"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
