# Implementation Plan: Native Terraform Tests And Examples Split

**Spec**: [spec.md](spec.md)
**Jira**: DMVP-9656
**Branch**: `agent/dmvp-9656-native-terraform-tests`

## Technical Context

**Artifact types**: Terraform configuration, Terraform native test files, GitHub workflow YAML, Markdown documentation.

**Primary artifacts**:

- `examples/<name>/{0-setup.tf,1-example.tf,README.md}` (moved from `tests/<name>/`)
- `tests/<name>.tftest.hcl` (new)
- `versions.tf` (new, root)
- `.github/workflows/terraform-test.yaml`
- `README.md`

**Governing standard**: `dasmeta/constitution`, `skills/terraform-module-developer/references/repository-baseline.md`.

## Approach

The four existing case directories already contained exactly what an example
needs — a provider setup file and a module invocation. Rather than deleting
them, they move to `examples/`, which simultaneously fills the repository's
missing examples axis and preserves their documentation value. Their
`main.tftest.hcl` files are removed, since assertions do not belong in examples.

Tests are then rewritten from scratch as native test files targeting the root
module, with the invocation expressed as `variables` blocks instead of a
duplicated `module` block.

## Steps

1. `git mv tests/<case> examples/<case>` for all four cases.
2. Remove `main.tftest.hcl` from the moved directories.
3. Add root `versions.tf` declaring `integrations/github`.
4. Write `tests/<case>.tftest.hcl` for each case, with a `provider` block, a `variables` block, and a `run` block.
5. Pin `terraform_version` in the test workflow.
6. Document the split, local verification commands, and CI checks in `README.md`.

## Verification

- `terraform fmt -check -recursive`
- `terraform init -backend=false`
- `terraform validate`
- `terraform test`

## Risks

- **Perceived coverage loss**: moving cases out of `tests/` looks like deleting tests. In fact coverage increases from zero executing cases to four.
- **Module-level change**: the root `versions.tf` steps outside setup-only scope and is called out explicitly for review.
- **Weak assertions**: plan-only cases will not catch behavioral regressions. Tracked as follow-up.
