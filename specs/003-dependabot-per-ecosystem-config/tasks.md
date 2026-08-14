# Tasks: Per-Ecosystem Dependabot Configuration

**Input**: Design documents from `/specs/003-dependabot-per-ecosystem-config/`
**Prerequisites**: spec.md, plan.md
**Jira**: DMVP-9656

## Phase 1: Investigation

- [X] T001 Confirm the reference `dasmeta/terraform-aws-rds/.github/dependabot.yaml` is actually working, by checking that repository receives Dependabot PRs from all three ecosystems
- [X] T002 Confirm `terraform-aws-rds` is a managed repository, so the module would overwrite that configuration
- [X] T003 Confirm the control plane does not override `dependabot` in `_.yaml`, so module defaults apply
- [X] T004 Confirm GitHub accepts both `dependabot.yml` and `dependabot.yaml`, correcting the review claim that `.yaml` is ignored

## Phase 2: Module Inputs

- [X] T005 [US2] Add the `updates` input to `modules/dependabot/variables.tf`
- [X] T006 [US3] Make `ecosystems` nullable and mark it deprecated
- [X] T007 [US2] Add `updates` to `modules/repository/variables.tf`
- [X] T008 [US2] Pass `updates` through in `modules/repository/files.tf`
- [X] T009 [US2] Add `updates` to the root `defaults.dependabot` object

## Phase 3: Rendering

- [X] T010 [US1] Add the Terraform module repository baseline as the default
- [X] T011 [US3] Derive updates from `ecosystems` when `updates` is unset
- [X] T012 Normalize all sources to one shape so the conditional type-checks
- [X] T013 [US2] Filter out entries with `enabled = false`
- [X] T014 [US1] Rewrite the template to emit `directories` or `directory`, and no `commit-message`
- [X] T015 Fix template whitespace: leading-tilde-only markers, since a trailing `~}` strips the following newline and collapses the YAML

## Phase 3b: Repository Types

- [X] T014a [US3] Confirm every ecosystem id used in a preset is one dependabot accepts
- [X] T014b [US3] Add the `repo_type` input with presets for terraform-module, terraform-setup, helm-chart, nodejs, php and none
- [X] T014c [US3] Validate `repo_type` against the known set so a typo fails the plan
- [X] T014d [US3] Thread `repo_type` through modules/repository and the root defaults
- [X] T014e [US3] Skip writing the file when no update is enabled, since dependabot rejects an empty updates list

## Phase 4: Verification

- [X] T016 [US1] Render the default and compare it semantically to the reference file
- [X] T017 [US2] Render with an entry disabled plus custom directories and interval
- [X] T018 [US4] Render from the legacy `ecosystems` input
- [X] T018a [US3] Render every repo_type preset and parse each as YAML
- [X] T018b [US3] Confirm an invalid repo_type fails the plan with the expected message
- [X] T019 `terraform validate` on root, `modules/repository`, `modules/dependabot`
- [X] T020 `terraform fmt -check -recursive`
- [X] T021 Existing native test suite still passes

## Deferred

- [ ] T022 Remove stray `.github/dependabot.yml` files from repositories that also carry the module-managed `.yaml`
- [ ] T023 Decide whether the generated `terraform-test` job should drop `continue-on-error: true` and gate CI
