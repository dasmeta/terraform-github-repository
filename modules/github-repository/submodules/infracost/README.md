# infracost

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
| <a name="input_name"></a> [name](#input\_name) | n/a | `list` | <pre>[<br>  "fold1",<br>  "fold2"<br>]</pre> | no |
| <a name="input_path"></a> [path](#input\_path) | n/a | `string` | `"${{ matrix.path }}"` | no |
| <a name="input_pr"></a> [pr](#input\_pr) | n/a | `string` | `"${{github.event.pull_request.number}}"` | no |
| <a name="input_ref"></a> [ref](#input\_ref) | n/a | `string` | `"'${{ github.event.pull_request.base.ref }}'"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |
| <a name="input_secret"></a> [secret](#input\_secret) | n/a | `string` | `"${{secret.API_KEY}}"` | no |
| <a name="input_token"></a> [token](#input\_token) | n/a | `string` | `"${{github.token}}"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
