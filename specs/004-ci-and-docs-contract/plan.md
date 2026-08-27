# Implementation Plan: CI, Required-Check And Documentation Contract

**Spec**: [spec.md](spec.md)
**Jira**: DMVP-10370 (area A), DMVP-10371
**Branch**: `agent/dmvp-10370-10371-ci-docs-contract`

## Technical Context

**Artifact types**: Terraform module source, generated workflow and configuration templates.

**Primary artifacts**:

- `modules/terraform-test/templates/terraform-test.yaml.tftpl`, `variables.tf`, `main.tf`, `output.tf`
- `modules/pre-commit/templates/.pre-commit-config.yaml.tftpl`, `pre-commit.yaml.tftpl`, new `.terraform-docs.yml.tftpl`
- `modules/repository/files.tf`, `modules/repository/variables.tf`
- `variables.tf` (root `defaults`)

**Upstream dependency**: `dasmeta/reusable-actions-workflows` 4.4.0, which makes the pre-commit action capable of failing and pins terraform-docs.

## Design Decisions

### A gate job, not a renamed matrix job

A matrix job's context carries the matrix value, so `terraform-validate` with a path matrix can only ever report `terraform-validate (./)`. Removing the matrix would give a stable name but lose per-path visibility, which the spec requires.

Splitting the two is what makes both possible: the matrix job is `validate` and reports `validate (<path>)` as visible detail, and a dependent job named `terraform-validate` is the required context. `needs` on a matrix aggregates to success only when every leg succeeded, and `if: always()` is what lets the gate run — and therefore report red — after a leg has failed. Without it the gate is skipped, and a skipped required check blocks rather than fails, which looks like a hung PR instead of a failed one.

### Documentation behaviour belongs in a committed file

The alternative was passing terraform-docs flags through hook `args`. That keeps CI and local runs in sync only as long as both invoke the hook identically, which is exactly the assumption that broke: CI installed 0.16.0 while contributors ran newer versions locally.

A committed `.terraform-docs.yml` moves the behaviour under review and makes it identical wherever terraform-docs runs. The relative `--config` path matters: the hook rewrites it to an absolute path from the repository root before entering each module directory, so a single root file governs every module. terraform-docs on its own does not search parent directories — verified — so relying on discovery instead of `--config` would have required one config file per module.

### Version pin and config file are not alternatives

The config pins *what* is rendered — sections, sort, anchors, output mode, markers. The version pins *how* it is rendered. Both are needed; the config is the larger lever and the version closes the remainder.

### Not migrating READMEs from the module

The hook migrates legacy markers itself from v1.93 via `replace_old_markers`. That covers 728 of the 812 affected files. The remaining 84 already carry both styles and would end up with two native marker pairs, so they are handled by a script in the control-plane repository, run before this reaches them. Doing it from the module was never possible: the module writes a fixed set of managed files and does not rewrite arbitrary READMEs.

### Backward compatibility

`terraform_test` and `pre_commit` stay booleans, so existing callers are untouched. Behaviour is configured through new optional objects, `terraform_test_configs` and `pre_commit_configs`, both defaulting to `null` and resolved with `try(...)`. Unset, the module renders the previous behaviour with the defects removed: native `terraform test` at the repository root.

## Verification

- `terraform validate` on root, `modules/repository`, `modules/pre-commit`, `modules/terraform-test`, `modules/dependabot`.
- `terraform test` in `modules/terraform-test`: 5 runs, and in `modules/pre-commit`: 5 runs.
- The rendered workflow and configuration are exposed as module outputs so tests assert against what is written to the repository, not against inputs. Every defect fixed here was invisible from the inputs.
- The docs-hook behaviour was verified end to end outside Terraform, with a scratch repository at `rev: v1.109.0` and a root `.terraform-docs.yml`: a legacy-only README migrated to native markers and regenerated; a README already carrying both ended with two native pairs; a module with no README got none.
- `terraform fmt -recursive` and `pre-commit run --all-files`.

## Risks

- **Previously green repositories will go red.** This is the first time either gate can fail. That is the intent, but the first run after adoption may surface work nobody expected. `fail-on-error: false` on the action is the per-repository escape hatch.
- **The pre-commit job is renamed**, so its status context changes from `terraform-validate` to `pre-commit`. Branch protection has to follow, using `rename-status-checks.py`, and only after the new workflow reaches default branches — renaming first blocks every open pull request.
- **Documentation churn.** Every README regenerates under a pinned 0.20.0 where CI previously ran 0.16.0. Chosen to be as small as possible, but it is not zero.
- **The 84 double-marker files must be cleaned first.** If this lands in those three repositories before the cleanup script runs, they gain a second native marker pair and need manual repair.
