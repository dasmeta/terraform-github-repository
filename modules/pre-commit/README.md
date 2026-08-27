# pre-commit

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs markers and calls<br/>replace\_old\_markers, which converts a legacy<br/>`BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK` pair into `BEGIN_TF_DOCS`<br/>in place. That is what migrates existing READMEs without a separate pass. | `string` | `"v1.109.0"` | no |
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
| <a name="input_actions_version"></a> [actions\_version](#input\_actions\_version) | Release of dasmeta/reusable-actions-workflows used by the generated<br/>workflow. Must be at least 4.4.0: earlier releases of the pre-commit action<br/>carried continue-on-error on both the run and the check step, and the check<br/>itself was `grep -q "Failed"`, which succeeds when hooks fail. The job could<br/>not report failure, so requiring its context in branch protection gated<br/>nothing. | `string` | `"4.4.0"` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Branch name to apply actions | `string` | n/a | yes |
| <a name="input_pre_commit_terraform_version"></a> [pre\_commit\_terraform\_version](#input\_pre\_commit\_terraform\_version) | Release of antonbabenko/pre-commit-terraform used by the generated<br/>.pre-commit-config.yaml. Must be at least v1.93: from that release the<br/>terraform\_docs hook uses the terraform-docs marker convention and calls<br/>replace\_old\_markers, which converts the hook's own older marker pair into<br/>the terraform-docs one in place. That is what migrates existing READMEs<br/>without a separate pass.<br/><br/>Note for maintainers: do not quote the older marker text literally in this<br/>description. It is rendered into README.md, where the docs hook then reads<br/>it as a real marker and the file never converges. | `string` | `"v1.109.0"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name to apply actions | `string` | n/a | yes |
| <a name="input_terraform_docs_version"></a> [terraform\_docs\_version](#input\_terraform\_docs\_version) | terraform-docs release used by the generated CI, without the leading v.<br/>Pin the same version locally: generated documentation differs between<br/>releases, so a mismatch makes every README look out of date on somebody's<br/>machine.<br/><br/>0.20.0 matches what managed repositories already have committed. 0.16.0<br/>emits `<br>` where the committed docs use `<br/>`, and 0.24.0 reflows table<br/>separators from `|------|` to `| ---- |`, which would rewrite every table in<br/>the fleet for output that renders identically. | `string` | `"0.20.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_files"></a> [files](#output\_files) | The list of files created/commited by workflow module |
| <a name="output_pre_commit_config"></a> [pre\_commit\_config](#output\_pre\_commit\_config) | The rendered .pre-commit-config.yaml, exposed for regression tests. |
| <a name="output_terraform_docs_config"></a> [terraform\_docs\_config](#output\_terraform\_docs\_config) | The rendered .terraform-docs.yml, exposed for regression tests. |
| <a name="output_workflow"></a> [workflow](#output\_workflow) | The rendered pre-commit workflow, exposed for regression tests. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
