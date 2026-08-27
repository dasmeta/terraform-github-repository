# Tasks: CI, Required-Check And Documentation Contract

**Spec**: [spec.md](spec.md) · **Plan**: [plan.md](plan.md)
**Jira**: DMVP-10370 (area A), DMVP-10371

## Prerequisites

- [x] T000 `reusable-actions-workflows` 4.4.0 released, with a pre-commit action that reports failure and pins terraform-docs

## Area A — CI and required-check contract

- [x] T001 Split the validation workflow into a `validate` matrix job and a dependent `terraform-validate` gate job
- [x] T002 Set `fail-fast: false` so one failing path does not cancel and hide the others
- [x] T003 Add `if: always()` to the gate so it reports failure rather than being skipped
- [x] T004 Add a `mode` input with `test` and `validate`, rejecting anything else at plan time
- [x] T005 Emit provider-independent steps for `validate` mode with no credentials and `-backend=false`
- [x] T006 Remove `continue-on-error` from both generated workflows
- [x] T007 Remove the undefined `matrix.path` reference from the pre-commit workflow
- [x] T008 Rename the pre-commit job to `pre-commit` to end the context collision
- [x] T009 Pin both generated workflows to the action release that can fail

## Area B — documentation contract

- [x] T010 Add a `.terraform-docs.yml` template and write it to each managed repository
- [x] T011 Point the docs hook at that config and drop the behavioural flags
- [x] T012 Bump `pre-commit-terraform` to a release that migrates legacy markers in place
- [x] T013 Pin terraform-docs to the version matching committed documentation
- [x] T014 Scope pull-request hook runs to changed files, keeping full runs on push

## Interface

- [x] T015 Add `terraform_test_configs` and `pre_commit_configs` at repository and root level, defaulting to `null`
- [x] T016 Keep `terraform_test` and `pre_commit` as booleans so existing callers are unaffected

## Verification

- [x] T017 Expose rendered workflow and configuration as outputs so tests assert on generated content
- [x] T018 Regression tests for the validation workflow — 5 runs
- [x] T019 Regression tests for the pre-commit and documentation setup — 5 runs
- [x] T020 Add the two new module directories to this repository's own test matrix
- [x] T021 `terraform validate` across root and all touched modules; `fmt` and `pre-commit` clean

## Follow-up, tracked elsewhere

- [ ] T022 Run `strip-legacy-tf-docs.py` against the three repositories carrying both marker styles, before this reaches them
- [ ] T023 Run `rename-status-checks.py` after the generated workflows reach default branches
- [ ] T024 Consider folding the provider-independent mode into the shared `terraform-test` action
- [ ] T025 Consider bumping terraform-docs to 0.24.0 as its own reflow commit per repository
