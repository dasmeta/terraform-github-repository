# tfsec

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_file.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch"></a> [branch](#input\_branch) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_commit_message_prefix"></a> [commit\_message\_prefix](#input\_commit\_message\_prefix) | The prefix for commit message | `string` | `"Change by terraform in repo workflow config"` | no |
| <a name="input_files"></a> [files](#input\_files) | The list of files to commit/push | <pre>list(object({<br>    remote_path = string # remote path of file to commit/push<br>    local_path  = string # local path to template file to generate file content<br>  }))</pre> | `[]` | no |
| <a name="input_overwrite_on_create"></a> [overwrite\_on\_create](#input\_overwrite\_on\_create) | Whether to override if file already exists | `bool` | `true` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository name to apply actions | `string` | n/a | yes |
| <a name="input_variables"></a> [variables](#input\_variables) | The map of data to pass to workflow template files | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_files"></a> [files](#output\_files) | The list of files created/commited by workflow module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
