# Feature Specification: CI, Required-Check And Documentation Contract

**Feature Branch**: `agent/dmvp-10370-10371-ci-docs-contract`
**Created**: 2026-08-27
**Status**: Implemented
**Jira**: DMVP-10370 (area A), DMVP-10371
**Input**: Managed repositories were accumulating repo-local CI exceptions because the generated workflows did not emit the contexts branch protection required, could not fail, and generated documentation that fought the documentation already committed.

## Problem

Three independent defects, all in generated files, all invisible from the module's inputs.

1. **The required context never existed.** The generated validation workflow put `strategy.matrix.path` on a job named `terraform-validate`, so it reported as `terraform-validate (./)`. Branch protection required the bare `terraform-validate`, which nothing produced. `terraform-any-analytics` PR #2 emitted successful per-path checks and was blocked anyway.

2. **Nothing could fail.** `continue-on-error: true` sat on the validation step in both generated workflows. One layer down, the shared pre-commit action carried it on two steps *and* used `grep -q "Failed"` as its check, which succeeds when hooks fail. Requiring either context gated nothing. Fixed in `reusable-actions-workflows` 4.4.0; this change adopts it.

3. **Documentation generation fought itself.** The `terraform_docs` hook ran with `--add-to-existing-file=true`, which uses the hook's own markers. Against a README already carrying terraform-docs markers it appended a *second* block. `--create-file-if-not-exist=true` additionally created READMEs in `examples/` and `tests/`. Meanwhile CI installed terraform-docs 0.16.0 while committed documentation is 0.20.0-shaped, so every run wanted to rewrite `<br/>` back to `<br>` — unnoticed, because of defect 2.

A fourth, smaller one: the generated pre-commit workflow referenced `path: modules/${{ matrix.path }}` with no `strategy` block, so the path resolved to `modules/`; and its job was also named `terraform-validate`, colliding with the validation workflow so branch protection could not distinguish them.

## Clarifications

### Session 2026-08-26

- Q: Which documentation marker convention should win? → A: the terraform-docs native `BEGIN_TF_DOCS` markers. Recorded against the evidence that the fleet is 812 files on the legacy convention versus 96 on the native one, so this is a deliberate normalization, not a correction of an outlier.
- Q: How is documentation behaviour kept identical between a local run and CI? → A: a `.terraform-docs.yml` committed to each repository by this module. Flags live in a file under review rather than in hook arguments. The hook rewrites a relative `--config` path to an absolute one from the repository root, so one file at the root governs every module.
- Q: Which terraform-docs version? → A: 0.20.0. Committed documentation across the managed repositories uses `<br/>` and tight `|------|` separators, which is 0.20.0 exactly; 0.16.0 emits `<br>` and 0.24.0 reflows separators to `| ---- |`, rewriting every table in roughly 900 files for identical rendering.
- Q: How does a stable required context coexist with per-path visibility? → A: the matrix job is renamed `validate`, and a separate job named `terraform-validate` depends on it. `needs` aggregates a matrix, so the gate is red unless every leg passed, while the legs stay individually visible.
- Q: Do existing READMEs need a migration pass? → A: only the 84 that already carry both marker styles. From v1.93 the hook calls `replace_old_markers`, which converts a legacy pair in place, so the other 728 migrate themselves. Verified end to end against v1.109.0.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Branch Protection Can Require One Stable Context (Priority: P1)

As a maintainer of a multi-module repository, I want one required check that does not change name when I add or remove a module.

**Acceptance Scenarios**:

1. **Given** three configured paths, **When** the workflow is rendered, **Then** a job named `terraform-validate` exists and depends on the matrix job.
2. **Given** three configured paths, **When** the workflow is rendered, **Then** each path is a separate matrix leg.
3. **Given** any path list, **When** the workflow is rendered, **Then** `fail-fast` is off, so one failing path does not cancel and hide the others.

---

### User Story 2 - A Failing Check Fails (Priority: P1)

As a reviewer, I want a red check to mean the validation failed.

**Acceptance Scenarios**:

1. **Given** either generated workflow, **When** it is rendered, **Then** `continue-on-error` does not appear.
2. **Given** the pre-commit workflow, **When** it is rendered, **Then** it pins an action release that reports failure.

---

### User Story 3 - Non-AWS Modules Validate Without Credentials (Priority: P1)

As a maintainer of a Helm-only or non-AWS module, I want validation that does not demand AWS credentials.

**Acceptance Scenarios**:

1. **Given** `mode = "validate"`, **When** the workflow is rendered, **Then** it configures no AWS credentials and runs `terraform init -backend=false`.
2. **Given** `mode = "test"`, **When** the workflow is rendered, **Then** it calls the shared action at the pinned release.
3. **Given** an unrecognized mode, **When** Terraform plans, **Then** it fails with the valid values listed.

---

### User Story 4 - Documentation Generation Is Reproducible (Priority: P1)

As a contributor, I want my local hook run to produce what CI produces.

**Acceptance Scenarios**:

1. **Given** the generated pre-commit configuration, **When** it is rendered, **Then** the docs hook reads `.terraform-docs.yml` and passes no behavioural flags.
2. **Given** the generated documentation configuration, **When** it is rendered, **Then** output mode is `inject` and the output file is `README.md`.
3. **Given** the generated workflow, **When** it is rendered, **Then** CI installs the same terraform-docs version the repositories have committed.
4. **Given** a module directory with no README, **When** the hook runs, **Then** no README is created.

---

### User Story 5 - Workflows Do Not Collide (Priority: P2)

As a maintainer, I want each workflow to report its own status context.

**Acceptance Scenarios**:

1. **Given** the pre-commit workflow, **When** it is rendered, **Then** its job is named `pre-commit` and no job is named `terraform-validate`.
2. **Given** the pre-commit workflow, **When** it is rendered, **Then** it references no matrix.

## Success Criteria *(mandatory)*

- **SC-001**: A stable `terraform-validate` context exists for single- and multi-path repositories, and is red unless every path passed.
- **SC-002**: Per-path results stay individually visible; no failure is hidden by fail-fast or `continue-on-error`.
- **SC-003**: `mode = "validate"` completes with no AWS credentials and no backend.
- **SC-004**: Native `terraform test` remains available and is the default.
- **SC-005**: The generated pre-commit workflow references no undefined matrix and shares no context name with the validation workflow.
- **SC-006**: Documentation behaviour is read from a committed `.terraform-docs.yml`, identical locally and in CI, at a pinned terraform-docs version.
- **SC-007**: No README is created where none exists; no second documentation block is appended where one exists.
- **SC-008**: Existing READMEs carrying only legacy markers migrate on the first hook run without manual intervention.

## Out Of Scope

- The 84 READMEs that already carry both marker styles. The hook converts their legacy pair into a second native pair, so they need `github-repositories/scripts/strip-legacy-tf-docs.py` run before this reaches them.
- Bumping terraform-docs to 0.24.0. Worth doing as its own reflow commit per repository, not bundled with a marker migration.
- Updating branch-protection contexts for the renamed pre-commit job. `github-repositories/scripts/rename-status-checks.py` exists for that and must run after the generated workflows reach default branches.
- Folding the provider-independent mode into the shared `terraform-test` action. The template emits the three steps directly; moving them into the action later is a clean follow-up.
