variable "repository_name" {
  description = "Repository name to apply actions"
  type        = string
}

variable "branch_name" {
  description = "Branch name to apply actions"
  type        = string
}

variable "actions_version" {
  description = <<-EOT
    Release of dasmeta/reusable-actions-workflows used by the generated
    workflow. Must be at least 4.4.0: earlier releases of the pre-commit action
    carried continue-on-error on both the run and the check step, and the check
    itself was `grep -q "Failed"`, which succeeds when hooks fail. The job could
    not report failure, so requiring its context in branch protection gated
    nothing.
  EOT
  type        = string
  default     = "4.4.0"
}

variable "terraform_docs_version" {
  description = <<-EOT
    terraform-docs release used by the generated CI, without the leading v.
    Pin the same version locally: generated documentation differs between
    releases, so a mismatch makes every README look out of date on somebody's
    machine.

    0.20.0 matches what managed repositories already have committed. 0.16.0
    emits `<br>` where the committed docs use `<br/>`, and 0.24.0 reflows table
    separators from `|------|` to `| ---- |`, which would rewrite every table in
    the fleet for output that renders identically.
  EOT
  type        = string
  default     = "0.20.0"
}

variable "pre_commit_terraform_version" {
  description = <<-EOT
    Release of antonbabenko/pre-commit-terraform used by the generated
    .pre-commit-config.yaml. Must be at least v1.93: from that release the
    terraform_docs hook uses the terraform-docs marker convention and calls
    replace_old_markers, which converts the hook's own older marker pair into
    the terraform-docs one in place. That is what migrates existing READMEs
    without a separate pass.

    Note for maintainers: do not quote the older marker text literally in this
    description. It is rendered into README.md, where the docs hook then reads
    it as a real marker and the file never converges.
  EOT
  type        = string
  default     = "v1.109.0"
}
