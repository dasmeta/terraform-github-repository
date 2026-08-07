# Tasks: Trivy Workflow Migration

**Input**: Design documents from `/specs/001-trivy-workflow-migration/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests/Validation**: Include validation tasks for every change. Formatting, static checks, the test suite, and a plan against a real repository are mandatory for changes to generated output.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g. US1, US2, US3, US4)
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: Establish what the shared actions offer and what the change will cost consumers.

- [X] T001 Confirm the shared actions ship a trivy action at the target version and inspect its inputs
- [X] T002 [P] Confirm whether the retired tfsec action still exists at that version, so the bump and the tool change can be judged separately
- [X] T003 Inventory every shared action reference in this repository, templates and own workflows
- [X] T004 Establish that the scan toggle can only live in the shared defaults object, since the per repository entry schema is closed

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Make the change verifiable before making it.

**⚠️ CRITICAL**: the suite could not initialise, so nothing about generated output was verifiable

- [X] T005 [US4] Remove the builtin test provider from all seven test setups
- [X] T006 [US4] Delete the three assertion files that compared a constant with itself
- [X] T007 [US4] Add a native test file per directory running the example with `command = plan`
- [X] T008 [US4] Assert the resolved repository name in the repository submodule tests, `full_name` is only known after apply
- [X] T009 [US4] Repair examples that predate the strict repositories object type, moving per repository settings into defaults
- [X] T010 [US4] Fix the `terraform-test` misspelling that silently disabled that workflow in an example
- [X] T011 [US4] Point the repository submodule tests at a real owner so they can run

**Checkpoint**: the suite runs, so generated output changes can be verified

---

## Phase 3: User Story 1 - Scan With a Maintained Tool (Priority: P1)

**Goal**: the generated scan runs trivy, with consistent naming across file, job and required check.

**Independent Test**: generate a repository with the scan enabled, confirm the workflow calls trivy and branch protection requires the job that reports it.

- [X] T012 [US1] Rename `modules/tfsec` to `modules/trivy` and its template to `trivy.yaml.tftpl`
- [X] T013 [US1] Point the generated file at `.github/workflows/trivy.yaml` and name the workflow `Trivy` with job `terraform-trivy`
- [X] T014 [US1] Call the trivy action, passing only `fetch-depth` so the action's scan defaults apply
- [X] T015 [US1] Rewire `modules/repository/files.tf` to the renamed submodule
- [X] T016 [US1] Require `terraform-trivy:15368` in `modules/repository/locals.tf`
- [X] T017 [US1] Plan against a real repository and confirm the workflow, job, action and status check

---

## Phase 4: User Story 2 - Keep Existing Callers Working (Priority: P2)

**Goal**: a caller pinning the old toggle sees no behaviour change.

**Independent Test**: plan a setup setting only the deprecated toggle and confirm the scan follows it.

- [X] T018 [US2] Rename the repository submodule input to `trivy` with a description naming the retired tool it replaces
- [X] T019 [US2] Add `trivy` to the defaults object and give `tfsec` a `null` default marking it deprecated
- [X] T020 [US2] Resolve the alias in `main.tf` so an explicitly set `tfsec` wins
- [X] T021 [US2] Plan with `tfsec = false` and confirm the scan resources disappear, 19 instead of 20

---

## Phase 5: User Story 3 - Keep Reusable Action References Current (Priority: P3)

**Goal**: one action version everywhere.

- [X] T022 [US3] Bump the five generated workflow templates to the current version
- [X] T023 [US3] Bump this repository's five own workflows, previously a version behind the templates
- [X] T024 [US3] Confirm no reference to an older version remains

---

## Phase 6: Polish & Documentation

- [X] T025 Update the README input tables and module list for the rename
- [X] T026 Run the full suite, all seven directories
- [X] T027 `terraform fmt -check -recursive`
- [X] T028 [P] Record decisions and rejected alternatives in [research.md](research.md)
- [X] T029 [P] Record the naming, toggle, delivery and rename contracts in [contracts/generated-workflows.md](contracts/generated-workflows.md)
- [X] T030 [P] Record commands, status and evidence in [quickstart.md](quickstart.md)
- [X] T031 Verify the status check rename path on a real repository, including that Terraform cannot perform it and the dedicated endpoint can

---

## Follow-ups (not in this feature)

- [ ] F001 Remove the deprecated `tfsec` input in the next major release
- [ ] F002 Decide whether per repository scan configuration is worth exposing, rather than inheriting the shared action defaults
- [ ] F003 Consider apply level tests for at least one directory, the suite verifies plans only
- [ ] F004 Align the terraform-docs version used by the pre-commit hook, it rewrites every README with unrelated formatting churn
