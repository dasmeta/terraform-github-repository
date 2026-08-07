# Quickstart: Trivy Workflow Migration

## Goal

Move the generated security scan from the retired tfsec to trivy, keep existing callers working, put every reusable action reference on one current version, and leave the test suite runnable.

## Steps

1. Confirm what the shared actions offer before deciding:

```bash
git -C ../reusable-actions-workflows ls-tree --name-only 4.3.0
git -C ../reusable-actions-workflows show 4.3.0:trivy/action.yml
```

2. Rename the scan submodule and its template, then point the generated file, workflow name, and job at the new tool:

```bash
git mv modules/tfsec modules/trivy
git mv modules/trivy/templates/tfsec.yaml.tftpl modules/trivy/templates/trivy.yaml.tftpl
```

3. Rewire the repository submodule: the module block, the input, and the required status check in `modules/repository/locals.tf`.

4. Add `trivy` to the defaults object and keep `tfsec` with a `null` default, resolving it in `main.tf` so the deprecated value wins when set.

5. Bump every shared action reference to the current version, in the generated templates and in this repository's own workflows.

6. Verify the default path, the deprecated path, and the whole suite:

```bash
export GITHUB_TOKEN=...   # needs the workflow permission, see below

# default: the scan is on and named after the new tool
terraform plan   # in a scratch config calling this module

# deprecated alias: tfsec = false must still switch the scan off
terraform plan   # in a scratch config with defaults = { tfsec = false }

# the suite
for d in tests/*/ modules/repository/tests/*/; do
  (cd "$d" && terraform init -backend=false >/dev/null && terraform test)
done

terraform fmt -check -recursive .
```

7. Release as a minor version, and tell consumers the migration ordering from
   [contracts/generated-workflows.md](contracts/generated-workflows.md).

## Consumer migration

1. upgrade the module version and apply, which adds `trivy.yaml`, removes `tfsec.yaml`, and opens a pull request per repository
2. merge those pull requests so `trivy.yaml` reaches the default branch
3. rename the required status check from `terraform-tfsec` to `terraform-trivy`, with the control plane tooling, never through Terraform

Doing step 3 first blocks every open pull request in the repository, because nothing reports the new context until step 2.

## Token requirement

Generated workflow files cannot be written with repository write access alone:

- classic token: `repo` and `workflow`
- fine grained token: `Workflows: Read and write`
- app token: `workflows: write`

Without it the API answers `404 Not Found` on `.github/workflows/*` paths only, while every other generated file writes normally. That asymmetry is the fingerprint.

## Current implementation status

- `modules/tfsec` renamed to `modules/trivy`; generated file is `.github/workflows/trivy.yaml`, workflow name `Trivy`, job `terraform-trivy`, calling the trivy action with `fetch-depth: 0`.
- Branch protection requires `terraform-trivy:15368`.
- `defaults.trivy` added, `defaults.tfsec` kept as a deprecated alias that wins when explicitly set.
- All ten shared action references pinned to `4.3.0`, previously split between `4.1.1` and `4.2.0`.
- Test suite migrated from the removed builtin test provider to native `terraform test`.

## Validation evidence

- All seven test directories pass: four root, three repository submodule.
- Default path planned against the live organisation: creates `trivy.yaml` with job `terraform-trivy`, requires `terraform-trivy:15368`.
- Deprecated path planned with `tfsec = false`: 19 resources instead of 20, no scan workflow and no scan status check.
- `terraform fmt -check -recursive` clean.
- The status check rename was exercised on a real repository: the update through Terraform fails as described in the contract, the dedicated endpoint succeeds, and Terraform then reports `No changes` for the protection resource.

## Known gaps

- The deprecated `tfsec` input stays until a major release.
- The scan configuration is whatever the shared action defaults to; per repository scan policy is not exposed.
- Test assertions are plan level only, so nothing verifies the applied result inside the suite; that is covered by applying against a real repository.
