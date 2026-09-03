# Regression coverage for the generated publishing workflow.
#
# The defect was a release race: two publishers running for the same commit
# fought over refs/notes/semantic-release, and the loser reported a failed
# check even though the release had succeeded in the other run. Part of that
# was this workflow triggering on pull requests as well as pushes.

# A note on yamldecode: YAML 1.1 reads a bare `on` key as a boolean, so the
# GitHub Actions trigger block decodes to the key "true", not "on". Every
# assertion below therefore indexes ["true"]. This is a property of the YAML
# spec rather than of this workflow, and it catches everyone once.

mock_provider "github" {}

variables {
  repository_name = "example-repo"
  branch_name     = "main"
}

run "publishes_only_on_pushes_to_release_branches" {
  command = plan

  # A pull request cannot publish: its ref is not one of the release branches.
  # Triggering there produced a `publish` check that said nothing, and on a
  # branch with an open pull request both events fired, so the publisher ran
  # twice for one push.
  assert {
    condition     = !can(yamldecode(output.workflow)["true"].pull_request)
    error_message = "Publishing must not trigger on pull requests; it can never release from one."
  }

  assert {
    condition     = yamldecode(output.workflow)["true"].push.branches == ["main", "master", "next"]
    error_message = "Publishing must trigger on the release branches, and only those."
  }
}

run "concurrent_pushes_are_serialised" {
  command = plan

  assert {
    condition     = can(yamldecode(output.workflow).concurrency.group)
    error_message = "Without a concurrency group two pushes race on refs/notes/semantic-release."
  }

  # Cancelling a release half way through is worse than making it wait.
  assert {
    condition     = yamldecode(output.workflow).concurrency.cancel-in-progress == false
    error_message = "Overlapping releases must queue, not cancel."
  }
}

run "one_publishing_job" {
  command = plan

  assert {
    condition     = length(keys(yamldecode(output.workflow).jobs)) == 1
    error_message = "This workflow must contain exactly one publishing job."
  }
}
