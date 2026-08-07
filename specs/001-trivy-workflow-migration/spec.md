# Feature Specification: Trivy Workflow Migration

**Feature Branch**: `[001-trivy-workflow-migration]`  
**Created**: 2026-08-07  
**Status**: Implemented  
**Input**: User description: "we do have newer 4.3.0 version of dasmeta/reusable-actions-workflows repo reusable actions, lets upgrade all github action we have/use here, also as tfsec got merged into trivy lets instead of using dasmeta/reusable-actions-workflows/tfsec action use dasmeta/reusable-actions-workflows/trivy one"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Scan With a Maintained Tool (Priority: P1)

As a maintainer of the repositories this module generates, I want the security scan workflow to run a tool that is still maintained, so that scanning keeps working and findings keep arriving.

**Why this priority**: tfsec is retired and its checks were absorbed into trivy. A generated workflow that calls a retired scanner produces decreasing value over time and eventually none.

**Independent Test**: Can be fully tested by generating a repository with the scan enabled and confirming the workflow file calls the trivy action, and that the required status check names the job that reports it.

**Acceptance Scenarios**:

1. **Given** a repository is generated with the security scan enabled, **When** the workflow file is written, **Then** it calls the trivy action rather than the tfsec one.
2. **Given** the scan job is renamed, **When** branch protection is generated, **Then** it requires the status check reported by the new job name.
3. **Given** the scan is disabled for a repository, **When** the repository is generated, **Then** no scan workflow is written and no scan status check is required.

---

### User Story 2 - Keep Existing Callers Working (Priority: P2)

As a consumer already setting the old toggle, I want my configuration to keep working after upgrading the module, so that the upgrade does not force a coordinated change across every setup I own.

**Why this priority**: the toggle is part of the module's public interface. Renaming an input without a transition breaks every caller that pins it, in a module used by many independent setups.

**Independent Test**: Can be fully tested by planning a setup that sets only the old toggle and confirming the scan is enabled or disabled exactly as before.

**Acceptance Scenarios**:

1. **Given** a caller sets the deprecated toggle to false, **When** the setup is planned, **Then** the scan workflow is not created.
2. **Given** a caller sets neither toggle, **When** the setup is planned, **Then** the scan workflow is created, matching the previous default.
3. **Given** a caller sets the deprecated toggle and the new one to conflicting values, **When** the setup is planned, **Then** the deprecated value wins, so the caller's existing intent is preserved.

---

### User Story 3 - Keep Reusable Action References Current (Priority: P3)

As a maintainer, I want every generated workflow to reference one current version of the shared actions, so that repositories do not drift across several versions.

**Why this priority**: references were split across two older versions, which means generated repositories were running different action code depending on when they were last applied.

**Independent Test**: Can be fully tested by searching the templates and this repository's own workflows for action references and confirming a single version appears.

**Acceptance Scenarios**:

1. **Given** the module generates any workflow, **When** the file is written, **Then** its action reference points at the current shared actions version.
2. **Given** this repository's own workflows, **When** they are inspected, **Then** they reference the same version as the generated ones.

---

### User Story 4 - Restore a Runnable Test Suite (Priority: P3)

As a maintainer, I want the test suite to run, so that changes to generated output can be verified before release rather than discovered by consumers.

**Why this priority**: the suite depended on a Terraform provider that no longer exists, so every directory failed before reaching a single assertion. A change of this size cannot be verified without it.

**Independent Test**: Can be fully tested by running the suite and observing that every directory reports a result rather than a provider error.

**Acceptance Scenarios**:

1. **Given** a current Terraform version, **When** the suite is run, **Then** every test directory initialises and reports pass or fail.
2. **Given** an example that predates the current input schema, **When** the suite is run, **Then** the example is valid and plans successfully.

### Edge Cases

- What happens to a repository whose branch protection still requires the old check after the scan job is renamed?
- What happens when a caller pins the deprecated toggle and never migrates?
- How does an assertion behave when the value it checks is only known after apply?
- What happens if the module version is upgraded but the required status check is never renamed?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The generated security scan workflow MUST call the trivy action.
- **FR-002**: The generated scan workflow file, its job, and the required status check MUST use consistent naming derived from the tool that runs.
- **FR-003**: The module MUST expose a toggle named after the current tool to enable or disable the scan.
- **FR-004**: The previous toggle MUST continue to work as a deprecated alias, and MUST win when explicitly set, so existing callers keep their behaviour.
- **FR-005**: With neither toggle set, the scan MUST be enabled, matching the previous default.
- **FR-006**: Every reference to the shared reusable actions MUST point at one current version, in generated templates and in this repository's own workflows.
- **FR-007**: The generated scan workflow MUST pass only the inputs the module intends to control, inheriting the action's own defaults for the rest.
- **FR-008**: The test suite MUST run on a current Terraform version without depending on removed providers.
- **FR-009**: Test examples MUST be valid against the module's current input schema.

### Consumer Impact Controls *(mandatory for interface changes)*

- **CIC-001**: Renaming the scan job changes the required status check, so consuming repositories MUST have their branch protection updated as part of the migration.
- **CIC-002**: The check rename MUST NOT be attempted through Terraform. The GitHub provider keeps the deprecated `contexts` attribute as optional+computed, so on update it sends stale contexts together with the new checks and the API rejects the call as a duplicate context. Setting `contexts = []` conflicts with `checks`.
- **CIC-003**: The migration MUST be ordered so that the new workflow reaches the default branch before the required check is renamed, otherwise every open pull request in the consuming repository is blocked on a check nothing reports.
- **CIC-004**: The release MUST be a minor version, not a patch, because the generated file set and the required status check change.
- **CIC-005**: Consuming setups MUST be told that the first apply after upgrading removes the old scan workflow file and adds the new one.

### Key Entities *(include if feature involves data)*

- **Scan Toggle**: The module input that enables the security scan, plus its deprecated alias.
- **Generated Workflow File**: The workflow written into a managed repository, named after the tool it runs.
- **Workflow Job**: The job inside the generated workflow, whose name becomes the status check context.
- **Required Status Check**: The branch protection entry naming the job that must pass before merge.
- **Shared Action Reference**: The pinned version of the reusable actions a generated workflow calls.

### Assumptions

- Consumers want the scan to keep running by default, so the new toggle keeps the previous default rather than defaulting off.
- The action's own defaults are the right scan configuration; the module does not need to pin scan type, scanners, severity, or exit code.
- Repositories managed by a control plane can have their required checks renamed in bulk by an operator, outside Terraform.
- The deprecated alias can be removed in a later major version once consumers have migrated.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated workflows reference the current shared actions version.
- **SC-002**: Zero generated workflows call the retired scanner.
- **SC-003**: A caller pinning only the deprecated toggle observes no behaviour change after upgrading.
- **SC-004**: Every test directory in the suite runs and passes.
- **SC-005**: Zero repositories are left requiring a status check that no workflow reports, when the documented migration order is followed.
