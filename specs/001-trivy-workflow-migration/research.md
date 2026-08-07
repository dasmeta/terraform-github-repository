# Research: Trivy Workflow Migration

## Decision 1: Rename fully rather than swap the action inside the old naming

- **Decision**: Rename the submodule, the generated workflow file, the job, the input, and the required status check, rather than keeping the tfsec names and only changing which action the step calls.
- **Rationale**: keeping tfsec names while running trivy leaves every generated repository with a file, a job, and a merge requirement named after a tool that no longer runs. The confusion is permanent and lands on consumers, not on this repository.
- **Cost accepted**: the required status check changes, so consuming repositories need a coordinated migration, see Decision 4.
- **Alternatives considered**:
  - Swap only the `uses:` line. Rejected as above, though it is the zero risk option and remains the fallback if a consumer cannot run the migration.
  - Rename the file and job but keep the input. Rejected because the input is the part consumers read most often.

## Decision 2: Keep the previous input as a deprecated alias

- **Decision**: Add `trivy` to the defaults object and keep `tfsec` with a `null` default. When `tfsec` is set it wins; otherwise `trivy` applies.
- **Rationale**: the defaults object is a public interface used by independent setups. Removing an input outright turns a module upgrade into a coordinated change across every consumer, for no benefit to them.
- **Precedence choice**: the deprecated input wins when explicitly set, because a caller that pinned it expressed intent about the scan, and silently ignoring that intent is worse than ignoring the newer name they never wrote.
- **Verification**: planned a setup with `tfsec = false` and confirmed the scan resources disappear, 19 resources instead of 20, with no scan status check.
- **Alternatives considered**:
  - Remove `tfsec` immediately. Rejected, it breaks callers on a minor upgrade.
  - Keep both as independent toggles. Rejected, two switches for one behaviour invites contradictory configuration.

## Decision 3: Inherit the action's scan defaults

- **Decision**: Pass only `fetch-depth` to the trivy action, leaving scan type, scanners, severity, and exit code at the action's defaults.
- **Rationale**: this mirrors what the tfsec step did, and keeps scan policy owned by the shared actions repository where it can be tuned once for everyone. Pinning them here would freeze policy into every generated repository at the moment it was last applied.
- **Alternatives considered**:
  - Write the scan inputs explicitly into the generated workflow. Rejected for the reason above, though it is the right choice if a consumer needs per repository scan policy.

## Decision 4: Perform the status check rename outside Terraform

- **Decision**: Rename the required status check in consuming repositories with an operator run tool, not through this module.
- **Finding**: Terraform cannot perform this update. The GitHub provider keeps the deprecated `contexts` attribute as optional+computed, so on update it sends the stale contexts together with the new checks and the API rejects the call with `Context must be unique per branch protection`. Pinning `contexts = []` is rejected as well, it conflicts with `checks`.
- **Evidence**: observed on a real repository, where state held `checks` with the new context and `contexts` with the old one at the same time. Provider `6.13.0` is the current release, so there is no fixed version to upgrade to.
- **Resolution**: the dedicated required status checks endpoint accepts a checks-only payload. After it is used, Terraform refreshes both attributes, sees no difference, and never sends the failing update. Verified: the resource reported `No changes` afterwards.
- **Alternatives considered**:
  - Replace the branch protection resource instead of updating it. Works, verified, but destroys and recreates protection, leaving a window where the default branch is unprotected. Rejected once the endpoint approach was found.
  - Ask consumers to fix each repository by hand. Rejected, 48 repositories in the first consumer alone.

## Decision 5: Order the migration so pull requests stay mergeable

- **Decision**: apply Terraform first, merge the generated pull requests, and only then rename the required checks.
- **Rationale**: the generated workflow lands on a working branch and reaches the default branch only when the generated pull request is merged. Renaming the required check before that leaves the default branch requiring a context that no workflow reports, which blocks every open pull request in that repository.
- **Correction**: the reverse order was proposed first, on the incorrect assumption that the check should be ready before the workflow arrives. It creates exactly the outage it was meant to avoid.

## Decision 6: Restore the test suite before shipping the change

- **Decision**: Replace the removed builtin test provider with native `terraform test`, and repair the examples, as part of this change rather than separately.
- **Rationale**: the suite could not initialise, so nothing about generated output was verifiable. Shipping a change to generated output without a working suite repeats the failure mode this repository has already seen, where a defect reached consumers and was found only during an apply.
- **Findings while repairing**:
  - three assertion files asserted a constant against itself and were deleted;
  - the linking example passed per repository settings the strict object type rejects, so the module's own documented linking path could not have worked;
  - `terraform-test` was spelled with a hyphen in one example, silently doing nothing;
  - `full_name` is only known after apply for a created repository, so plan level assertions use the resolved name instead.

## Decision 7: Release as a minor version

- **Decision**: the change ships as a `feat`, producing a minor release.
- **Rationale**: the generated file set changes, an input is renamed, and a branch protection requirement changes. A patch release would let consumers pick this up without reading anything, and the check rename is not safe to apply unattended.

## Out of scope

- Removing the deprecated `tfsec` input, which belongs to a later major release.
- Per repository scan configuration.
- The operator tooling that performs the check rename, which lives with the control plane that owns the repository list.
