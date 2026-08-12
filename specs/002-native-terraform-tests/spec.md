# Feature Specification: Native Terraform Tests And Examples Split

**Feature Branch**: `agent/dmvp-9656-native-terraform-tests`
**Created**: 2026-08-12
**Status**: Implemented
**Jira**: DMVP-9656
**Input**: Adopt the module repository baseline defined in `dasmeta/constitution` (`specs/046-tf-module-repo-baseline`), moving verification onto Terraform's native test framework and separating consumer documentation from tests.

## Problem

This repository shipped four test cases at `tests/<case>/main.tftest.hcl`, each pairing `0-setup.tf` and `1-example.tf` with a `main.tftest.hcl` containing a bare `run "plan"` block.

None of those tests were executing.

1. `terraform test` discovers `*.tftest.hcl` in the test directory only and does not recurse. Files one level down were never found. Verified empirically with Terraform 1.14.7.
2. The `terraform-test` action consumed at `@4.3.0` defaulted to Terraform 1.3.6, which predates `.tftest.hcl` parsing entirely.
3. That action also never ran `terraform init`.

The repository also had no `examples/` directory, so it failed the required examples axis of the baseline, and the root module declared no `required_providers`, so nothing could target it as the module under test.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Tests Run And Report Truthfully (Priority: P1)

As a maintainer, I want `terraform test` to actually execute this module's cases, so a green check means the module still plans across its supported input shapes.

**Independent Test**: Run `terraform test` at the repository root and observe four cases execute.

**Acceptance Scenarios**:

1. **Given** the repository root, **When** `terraform test` runs, **Then** four cases are discovered and pass.
2. **Given** the root module, **When** a test supplies a `github` provider block, **Then** the provider resolves to `integrations/github`.
3. **Given** CI, **When** the test workflow runs, **Then** it uses a Terraform version supporting the native framework.

---

### User Story 2 - Examples Are Documentation, Tests Are Verification (Priority: P2)

As a module consumer, I want readable examples separate from test machinery, so I can copy a working invocation without reading assertions.

**Acceptance Scenarios**:

1. **Given** `examples/<name>/`, **When** it is inspected, **Then** it contains `0-setup.tf` and `1-example.tf` and no test files.
2. **Given** `tests/`, **When** it is inspected, **Then** it contains only `.tftest.hcl` files at the top level.
3. **Given** `README.md`, **When** a maintainer reads it, **Then** local verification commands and the CI checks that gate a pull request are documented.

## Success Criteria *(mandatory)*

- **SC-001**: `terraform test` discovers and passes four cases from the repository root.
- **SC-002**: `terraform fmt -check -recursive` and `terraform validate` pass.
- **SC-003**: Four examples exist under `examples/` using the numbered layout, carrying no assertions.
- **SC-004**: The test workflow pins a Terraform version >= 1.6 rather than relying on the action default.
- **SC-005**: `README.md` documents the examples/tests split, local verification commands, and CI checks.

## Design Notes

### The root module gained a versions.tf

Tests target the repository root module. The root previously declared no
`required_providers`, so a `github` provider block in a test file would resolve
to `hashicorp/github` rather than `integrations/github`. A root `versions.tf`
was added mirroring `modules/repository/versions.tf`.

This is a module-level change rather than setup-only work. It is judged low risk
because consumers already receive the same requirement transitively through the
child module, and the `required_version` floor is unchanged at `>= 1.3`.

### The version floor was deliberately not raised

Native tests need Terraform >= 1.6 to *run*, but `required_version` is the
consumer compatibility contract. Raising it to `1.6` would break consumers on
older Terraform for no functional gain, so the floor stays at `>= 1.3` and the
version requirement is met by the CI runner instead.

### Assertions are limited to a clean plan

The root module exposes no outputs, so there is nothing behavioral to assert
against. Each case runs `command = plan`, which still catches type errors,
invalid input shapes, and broken child-module wiring across four distinct
configurations. Adding root outputs would enable real assertions and is tracked
as deferred follow-up.

## Out Of Scope

- Adding root outputs to enable behavioral assertions.
- Upgrading the `terraform-test` action reference beyond pinning its Terraform version; the action's own defects are fixed in `dasmeta/reusable-actions-workflows`.
