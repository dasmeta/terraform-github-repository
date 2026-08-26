# Implementation Plan: Per-Ecosystem Dependabot Configuration

**Spec**: [spec.md](spec.md)
**Jira**: DMVP-9656
**Branch**: `agent/dmvp-9656-dependabot-config`

## Technical Context

**Artifact types**: Terraform module source and a template file.

**Primary artifacts**:

- `modules/dependabot/variables.tf`
- `modules/dependabot/main.tf`
- `modules/dependabot/templates/dependabot.yaml.tftpl`
- `modules/repository/variables.tf`, `modules/repository/files.tf`
- `variables.tf` (root `defaults.dependabot`)

## Design Decisions

### Omit `commit-message` rather than choosing a prefix

The original defect was `prefix: feat` publishing minor releases. Rather than substituting `chore` or `fix`, the template emits no `commit-message` block at all. Dependabot then applies its own conventional prefix (`build(deps)`), which semantic-release does not treat as releasable. This matches the reference configuration and avoids encoding a release-policy decision in a shared module.

### `updates` replaces `ecosystems`, which is retained

`ecosystems` is a flat list and cannot express directories, intervals, or per-entry toggles. The new `updates` input is a list of objects. `ecosystems` is kept and honored when `updates` is unset, so existing callers are unaffected. Both default to `null` so the module can distinguish "not set" from "set to the old default" and fall back to the new baseline.

### Normalize every source to one shape

Terraform types tuples by both length and element type, so a conditional choosing between the default list, the legacy list, and a caller list fails to type-check when their shapes differ — `directories` present in one element and `null` in another is enough to break it. This was caught by testing rather than review. Each source is therefore normalized before the conditional: `directories` is always a list (empty means "use `directory`") and `directory` is always a string. The template branches on `length(directories) > 0`.

### Default expresses the module-repository baseline, not a universal one

The default encodes what a Terraform module repository needs. Other repository types override `updates` wholesale rather than the module trying to infer type.

## Verification

Rendering was exercised against the real module locals in a harness, for three scenarios:

1. nothing set — output parsed and compared to `terraform-aws-rds/.github/dependabot.yaml`; semantically equal
2. `enabled = false` on one entry plus custom `directories` and `interval` — entry omitted, overrides honored
3. legacy `ecosystems` — renders weekly root-directory entries

Plus `terraform validate` on root, `modules/repository`, and `modules/dependabot`, `terraform fmt -check -recursive`, and the existing native test suite.

## Risks

- **Changed defaults**: repositories previously receiving two daily ecosystems now receive three weekly ones with submodule coverage. This is the intended correction, but it changes generated content in every managed repository on the next apply.
- **Overwriting hand-tuned configuration**: repositories that hand-wrote a good `dependabot.yaml`, such as `terraform-aws-rds`, are brought under module control. Because the default now matches that reference, the result should be a no-op there — verified semantically, though the exact byte formatting will differ in quoting.
