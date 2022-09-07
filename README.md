## Why
Modules to quickly spin up fully functional of github repository.
Using pre-commit hooks
Using semantic-release versioning

## What hooks we use

We use terraform-fmt, terraform-docs, trailing whitespace, detect-aws-credentials, check-merge-conflict, detect-private-key.

## Requirements for pre-commit hooks
for Run our pre-commit hooks you need to install
	- terraform
	- terraform-docs

## Config for GitHooks

```bash
git config core.hooksPath githooks
```

## What
- gitub-repository
