# Implementation Plan: Trivy Workflow Migration

**Branch**: `[001-trivy-workflow-migration]` | **Date**: 2026-08-07 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/001-trivy-workflow-migration/spec.md`

## Summary

Replace the retired tfsec scan with trivy across the generated workflows: rename the submodule, the generated workflow file, its job, the module input, and the required status check that names the job. Keep the previous input working as a deprecated alias so existing callers are not forced into a coordinated change. Pin every reusable action reference to one current version. Restore the test suite, which could not run at all, so the change is verifiable before release.

## Technical Context

**Language/Version**: Terraform, `>= 1.3.0`  
**Primary Dependencies**: `integrations/github` provider, `dasmeta/reusable-actions-workflows` shared actions  
**Storage**: none, the module writes files and settings into GitHub repositories  
**Testing**: native `terraform test` with `command = plan` per test directory, plus plans against the live organisation  
**Target Platform**: GitHub repositories managed through this module  
**Project Type**: Terraform module  
**Performance Goals**: one scan tool and one action version across every generated repository  
**Constraints**: the module's inputs are a public interface used by independent setups; renaming the scan job changes a branch protection requirement in every consuming repository; generated files land on a working branch and only reach the default branch when the generated pull request is merged  
**Scale/Scope**: 1 submodule renamed, 10 action references bumped, 1 input renamed with an alias, 7 test directories restored

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] Consumer impact is explicit: the renamed input, generated file set, and required status check are listed.
- [x] Backward compatibility is explicit: the deprecated alias and its precedence are documented.
- [x] Release type is explicit: minor, because generated output and a branch protection requirement change.
- [x] Validation strategy is explicit: the full test suite plus plans against real repositories.
- [x] Migration is reproducible: the ordering and the tooling that performs the check rename are documented.

## Project Structure

### Documentation (this feature)

```text
specs/001-trivy-workflow-migration/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/
│   └── requirements.md
├── contracts/
│   └── generated-workflows.md
└── tasks.md
```

### Source Code (repository root)

```text
.
├── .github/workflows/          # this repository's own workflows
├── main.tf                     # maps defaults onto the repository submodule
├── variables.tf                # the defaults object, holds both toggles
├── modules/
│   ├── repository/             # per repository resources and status checks
│   ├── trivy/                  # renamed from modules/tfsec
│   └── workflow-files-base/    # writes generated files into a repository
└── tests/                      # root module test directories
```

**Structure Decision**: The feature keeps the existing layout. The scan submodule is renamed rather than duplicated, so there is exactly one scan implementation, and the deprecated input is resolved in the root module so the submodule only knows the current name.

## Phase 0 Research Outcome

- The shared actions ship a trivy action from the current version, and the retired tfsec action is still present, so the bump alone does not force the tool change; the tool change is a deliberate choice.
- The generated scan job name becomes the status check context, so the job name, the workflow file name, and the required check are one coupled decision, not three.
- The per repository entry schema accepts only name, description, topics, and pages, so a scan toggle can only be expressed through the shared defaults object.
- The test suite depended on a builtin test provider that current Terraform no longer ships, so no test directory could initialise.
- Several test examples predate the strict repositories object type and were invalid regardless of the provider problem.

## Phase 1 Design Summary

- Rename `modules/tfsec` to `modules/trivy`; write `.github/workflows/trivy.yaml` with job `terraform-trivy` calling the trivy action.
- Require `terraform-trivy` in branch protection instead of `terraform-tfsec`.
- Rename the repository submodule input to `trivy`; resolve the deprecated `tfsec` input in the root module, where it wins when explicitly set.
- Pass only `fetch-depth` to the action, inheriting its scan defaults.
- Bump every shared action reference to the current version, in templates and in this repository's own workflows.
- Replace the removed test provider with native `terraform test`, and repair examples against the current schema.

## Impacted Artifacts

- Renamed: `modules/tfsec/**` to `modules/trivy/**`, including the template
- Changed: `main.tf`, `variables.tf`, `modules/repository/files.tf`, `modules/repository/locals.tf`, `modules/repository/variables.tf`
- Changed: five generated workflow templates and five workflows of this repository
- Changed: seven test directories, three dummy assertion files removed
- Documentation: `README.md`

## Post-Design Constitution Check

- [x] Consumer impact remains explicit and is repeated in the release notes.
- [x] Backward compatibility holds: a caller pinning only the deprecated input sees no change.
- [x] Release remains minor.
- [x] Validation ran: all seven suites pass, plus plans against real repositories.
- [x] Migration ordering is documented in the contract and in the consuming control plane's tooling.
