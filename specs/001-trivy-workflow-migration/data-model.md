# Data Model: Trivy Workflow Migration

## Scan Toggle

- **Purpose**: Decides whether a managed repository receives the security scan workflow.
- **Fields**:
  - `trivy`: current input, boolean, defaults to enabled
  - `tfsec`: deprecated alias, boolean or null, defaults to null meaning unset
  - `resolved`: the value passed to the repository submodule
- **Resolution rule**: `resolved = tfsec == null ? trivy : tfsec`, so an explicitly set deprecated value wins.
- **Validation rules**:
  - Only settable through the shared defaults object; the per repository entry schema accepts name, description, topics and pages only.
  - With both unset the scan is enabled, matching the behaviour before this change.

## Generated Workflow File

- **Purpose**: The workflow written into a managed repository.
- **Fields**:
  - `path`: `.github/workflows/<tool>.yaml`
  - `job`: the job identifier inside the file
  - `action_reference`: shared action and pinned version
  - `branch`: the working branch the file is written to
- **Validation rules**:
  - Path, job, and required status check are derived from the same tool name.
  - Written to the working branch, so it reaches the default branch only when the generated pull request merges.
  - Writing under `.github/workflows/` requires a token permission beyond repository write.

## Workflow Job

- **Purpose**: The unit whose name becomes the status check context reported to GitHub.
- **Fields**:
  - `name`: job identifier, `terraform-trivy`
  - `reports_context`: the status check name GitHub records
- **Validation rules**:
  - Renaming the job renames the context, which is why it cannot be changed independently of branch protection.

## Required Status Check

- **Purpose**: The branch protection entry that must pass before a pull request merges.
- **Fields**:
  - `context`: the job name
  - `app_id`: the application reporting it
  - `strict`: whether the branch must be up to date
- **Validation rules**:
  - Must name a job that some workflow on the default branch actually reports, otherwise pull requests cannot merge.
  - Managed by this module at creation time, but renames must be performed outside Terraform, see the contract.

## Shared Action Reference

- **Purpose**: The pinned version of the reusable actions a generated workflow calls.
- **Fields**:
  - `action`: action path within the shared repository
  - `version`: pinned tag
- **Validation rules**:
  - One version across all generated templates and this repository's own workflows.

## Scan Migration Mapping

| Aspect | Before | After |
|---|---|---|
| submodule | `modules/tfsec` | `modules/trivy` |
| template | `templates/tfsec.yaml.tftpl` | `templates/trivy.yaml.tftpl` |
| generated file | `.github/workflows/tfsec.yaml` | `.github/workflows/trivy.yaml` |
| workflow name | `TFSEC` | `Trivy` |
| job | `terraform-tfsec` | `terraform-trivy` |
| required check | `terraform-tfsec:15368` | `terraform-trivy:15368` |
| module input | `tfsec` | `trivy`, `tfsec` deprecated alias |
| action | `reusable-actions-workflows/tfsec` | `reusable-actions-workflows/trivy` |

## Action Version Reconciliation

| Location | Before | After |
|---|---|---|
| `modules/checkov/templates` | `4.2.0` | `4.3.0` |
| `modules/pre-commit/templates` | `4.2.0` | `4.3.0` |
| `modules/terraform-test/templates` | `4.2.0` | `4.3.0` |
| `modules/tflint/templates` | `4.2.0` | `4.3.0` |
| `modules/trivy/templates` | `4.2.0`, tfsec action | `4.3.0`, trivy action |
| this repository's five workflows | `4.1.1` | `4.3.0` |

## Test Directory

- **Purpose**: An example configuration exercised by the suite.
- **Fields**:
  - `setup`: provider and version requirements
  - `example`: the module call under test
  - `test_file`: native test definition running the example as a plan
- **Validation rules**:
  - Must not depend on providers removed from current Terraform.
  - The example must be valid against the module's current input schema.
  - Assertions may only reference values known at plan time.
