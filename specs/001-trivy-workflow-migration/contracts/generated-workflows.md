# Contract: Generated Workflows and Status Checks

## Purpose

Define what consumers can rely on when this module generates workflow files and branch protection, and what they must do themselves when a generated job is renamed.

## Naming Contract

A scan or check feature owns three names that MUST stay derived from one tool name:

| Artifact | Pattern | Example |
|---|---|---|
| generated file | `.github/workflows/<tool>.yaml` | `.github/workflows/trivy.yaml` |
| workflow job | `terraform-<tool>` | `terraform-trivy` |
| required status check | `terraform-<tool>:<app id>` | `terraform-trivy:15368` |

Renaming any one of them renames all three. A change to the job name is therefore a change to what consuming repositories require before merge, and is never an internal refactor.

## Toggle Contract

- Feature toggles are set through the shared `defaults` object, not per repository. The `repositories` entry schema accepts `name`, `description`, `topics` and `pages` only.
- A renamed toggle MUST keep the previous name working for at least one minor release.
- When both the current and the deprecated toggle are set, the deprecated one wins, preserving the intent of a caller who has not migrated yet.
- With neither set, the previous default applies.

## Generated File Delivery Contract

- Generated files are written to the working branch, `branch_toPush`, not to the default branch.
- They reach the default branch only when the generated pull request is merged.
- Consumers MUST treat the first apply after upgrading as a change to their repositories: a pull request is opened, and files are added and removed on the working branch.
- Writing under `.github/workflows/` requires a token permission beyond repository write: `workflow` for a classic token, `Workflows: Read and write` for a fine grained token, `workflows: write` for an app token. Without it the API answers `404`, which reads like a missing repository.

## Status Check Rename Contract

Terraform MUST NOT be used to rename a required status check on an existing repository.

- The GitHub provider keeps the deprecated `contexts` attribute as optional+computed. On update it sends the stale contexts together with the new checks, and the API rejects the call with `Context must be unique per branch protection`.
- Setting `contexts = []` does not help, it conflicts with `checks`.
- Provider `6.13.0`, the current release at the time of writing, behaves this way.

Use the dedicated required status checks endpoint, which accepts a checks-only payload and avoids the deprecated field. Afterwards Terraform refreshes both attributes, sees no difference, and never sends the failing update. No branch protection is destroyed and no repository is left unprotected.

### Required ordering

1. apply Terraform, so the new workflow file is added and its pull request opens
2. merge those pull requests, so the workflow reaches the default branch
3. rename the required status checks

Renaming first leaves the default branch requiring a context that nothing reports, blocking every open pull request until step 2. The reverse order must not be used.

### Tooling

The control plane that owns the repository list performs the rename. For the DasMeta setup that is `scripts/rename-status-checks.py` in `dasmeta/github-repositories`, which is dry run by default, takes repeatable `--map OLD=NEW` pairs, and refuses to widen an explicitly requested but empty repository selection to the whole organisation.

## Release Contract

- A change to the generated file set, a renamed input, or a renamed status check is a minor release, never a patch.
- Release notes MUST state which files consuming repositories will gain and lose, and MUST link the migration ordering above.

## Verification Contract

- Every test directory MUST run under native `terraform test` and pass.
- Assertions MUST only reference values known at plan time; `full_name` is computed for a created repository and cannot be asserted before apply.
- A change to generated output MUST additionally be verified with a plan against a real repository, because configuration validation does not exercise resources gated by `count` and will pass on configurations that cannot plan.
