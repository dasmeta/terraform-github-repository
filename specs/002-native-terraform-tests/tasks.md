# Tasks: Native Terraform Tests And Examples Split

**Input**: Design documents from `/specs/002-native-terraform-tests/`
**Prerequisites**: spec.md, plan.md
**Jira**: DMVP-9656

## Phase 1: Investigation

- [X] T001 Verify `terraform test` does not discover `tests/<case>/main.tftest.hcl`
- [X] T002 Confirm the consumed `terraform-test@4.3.0` action defaults to Terraform 1.3.6
- [X] T003 Confirm the root module declares no `required_providers`
- [X] T004 Confirm test working files are gitignored and untracked

## Phase 2: Examples

- [X] T005 [US2] Move `tests/basic-create` to `examples/basic-create`
- [X] T006 [US2] Move `tests/basic-link` to `examples/basic-link`
- [X] T007 [US2] Move `tests/full-enabled-create` to `examples/full-enabled-create`
- [X] T008 [US2] Move `tests/repositories` to `examples/repositories`
- [X] T009 [US2] Remove `main.tftest.hcl` from the moved example directories

## Phase 3: Root Module

- [X] T010 [US1] Add root `versions.tf` declaring `integrations/github >= 5.39.0` and `required_version >= 1.3`
- [X] T011 [US1] Confirm the `required_version` floor is left unchanged rather than raised to 1.6

## Phase 4: Native Tests

- [X] T012 [US1] Write `tests/basic-create.tftest.hcl`
- [X] T013 [US1] Write `tests/basic-link.tftest.hcl`
- [X] T014 [US1] Write `tests/full-enabled-create.tftest.hcl`
- [X] T015 [US1] Write `tests/repositories.tftest.hcl`
- [X] T016 [US1] Document in each file why a clean plan is the assertion

## Phase 5: CI And Documentation

- [X] T017 [US1] Pin `terraform_version: 1.9.8` in `.github/workflows/terraform-test.yaml`
- [X] T018 [US2] Document the examples/tests split in `README.md`
- [X] T019 [US2] Document local verification commands and CI checks in `README.md`

## Phase 6: Verification

- [X] T020 `terraform fmt -check -recursive` passes
- [X] T021 `terraform validate` passes
- [X] T022 `terraform test` discovers and passes four cases

## Deferred

- [ ] T023 Add root outputs so tests can assert on behavior rather than a clean plan
- [ ] T024 Move to a `terraform-test` action release that includes the init step and discovery guard, then drop the local `terraform_version` pin if the new default suffices
