# Feature Specification: Per-Ecosystem Dependabot Configuration

**Feature Branch**: `agent/dmvp-9656-dependabot-config`
**Created**: 2026-08-14
**Status**: Implemented
**Jira**: DMVP-9656
**Input**: Review findings on `terraform-renderer-generic#17`, plus a request to adopt `dasmeta/terraform-aws-rds/.github/dependabot.yaml` as the default shape for Terraform module repositories, with the ability to switch individual updates on and off and to vary configuration by repository type.

## Problem

The generated Dependabot configuration was wrong in four ways, and would have been written to every managed repository on the next apply.

1. **Spurious releases.** The template hardcoded `commit-message.prefix: feat`. With semantic-release, every merged Dependabot bump publishes a **minor** version, even though no feature was added.
2. **Submodules never scanned.** Every entry used `directory: "/"`, so provider and module versions under `modules/*` were never checked. A module repository keeps most of its Terraform there.
3. **Missing ecosystem.** The default was `["github-actions", "terraform"]`, so the npm tooling that drives semantic-release and commitlint was never updated.
4. **Daily noise.** The interval was `daily` rather than the weekly cadence used in practice.

The reference configuration in `dasmeta/terraform-aws-rds` already solves all four and is demonstrably working: that repository receives Dependabot pull requests from all three ecosystems (`terraform`, `github_actions`, `npm_and_yarn`). Because `terraform-aws-rds` is a managed repository, the next apply would have **overwritten that good configuration** with the defective generated one.

## Clarifications

### Session 2026-08-14

- Q: What should the default be for Terraform module repositories? → A: The `terraform-aws-rds` shape — `terraform` across `/` and `/modules/*`, plus `github-actions` and `npm` at the root, all weekly.
- Q: How should individual updates be switched off? → A: An `enabled` flag per entry, so the entry stays documented in configuration while being omitted from the rendered file.
- Q: How should configuration vary by repository type? → A: A `repo_type` input selects a named preset. `terraform-module` is the default because most managed repositories are module repositories today, but the module is expected to be used across Terraform setup, Helm chart, Node.js and PHP repositories, each needing a different ecosystem set. `updates` still overrides any preset.
- Q: What happens when a repository type selects no updates? → A: No configuration file is written at all. Dependabot rejects a config whose `updates` key has no entries, so an empty file is worse than none.
- Q: What commit prefix should be used? → A: None. Omitting `commit-message` lets Dependabot apply its own conventional prefix (`build(deps)`), which semantic-release does not treat as a release. This removes the need to choose between `feat`, `fix`, and `chore`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Module Repositories Get A Correct Baseline (Priority: P1)

As a maintainer of a Terraform module repository, I want the generated Dependabot configuration to cover the root, submodules, workflow actions, and npm tooling, so dependency updates are not silently missed.

**Acceptance Scenarios**:

1. **Given** no Dependabot configuration is supplied, **When** the file is rendered, **Then** it matches the `terraform-aws-rds` reference semantically.
2. **Given** the default configuration, **When** it is inspected, **Then** `terraform` scans both `/` and `/modules/*`.
3. **Given** the default configuration, **When** it is inspected, **Then** no `commit-message` prefix is emitted.

---

### User Story 2 - Individual Updates Can Be Switched Off (Priority: P1)

As a maintainer, I want to disable one ecosystem without deleting its configuration, so the intent stays visible.

**Acceptance Scenarios**:

1. **Given** an entry with `enabled = false`, **When** the file is rendered, **Then** that ecosystem is absent and the others are unaffected.
2. **Given** an entry with a custom `interval` and `directories`, **When** the file is rendered, **Then** both are honored.

---

### User Story 3 - Repository Types Select Their Own Defaults (Priority: P1)

As a maintainer onboarding a non-Terraform repository, I want the default update set to match the repository type, so I do not have to spell out ecosystems every time.

**Acceptance Scenarios**:

1. **Given** `repo_type = "php"`, **When** the file is rendered, **Then** it configures `composer` and `github-actions`.
2. **Given** `repo_type = "helm-chart"`, **When** the file is rendered, **Then** it configures `helm` and `github-actions`.
3. **Given** an unrecognized `repo_type`, **When** Terraform plans, **Then** it fails with a message listing the valid values.
4. **Given** `repo_type = "none"` and no `updates`, **When** the module runs, **Then** no configuration file is written.

---

### User Story 4 - Existing Callers Keep Working (Priority: P2)

As an existing consumer passing `ecosystems`, I want my configuration to keep working after upgrading.

**Acceptance Scenarios**:

1. **Given** `ecosystems = ["github-actions", "terraform"]`, **When** the file is rendered, **Then** both appear as weekly root-directory updates.
2. **Given** both `ecosystems` and `updates`, **When** the file is rendered, **Then** `updates` wins.

## Success Criteria *(mandatory)*

- **SC-001**: The default rendered file is semantically identical to the `terraform-aws-rds` reference.
- **SC-002**: `terraform` scans `/` and `/modules/*` by default.
- **SC-003**: No `commit-message` prefix is emitted, so dependency bumps do not publish minor releases.
- **SC-004**: A per-entry `enabled` flag omits that ecosystem from the rendered file.
- **SC-005**: The legacy `ecosystems` input continues to work unchanged.
- **SC-007**: `repo_type` selects a preset per repository type, defaulting to `terraform-module`, and an unrecognized value fails the plan with the valid values listed.
- **SC-008**: When no update is enabled, no configuration file is written rather than an empty one.
- **SC-006**: Root, `modules/repository`, and `modules/dependabot` all validate, and the existing native tests still pass.

## Out Of Scope

- Removing the stray `.github/dependabot.yml` files that exist in some repositories alongside the module-managed `.yaml`. GitHub accepts either extension, but a repository carrying both has two competing configurations; that cleanup is tracked separately.
- Making the generated `terraform-test` job blocking by removing `continue-on-error: true`.
