name: Tflint
on:
  pull_request:
  push:
    branches: [main, master]

jobs:
  terraform-validate:
    permissions:
      actions: write
      contents: write
      discussions: write
      pull-requests: write
      id-token: write
      security-events: write
    runs-on: ubuntu-latest
    strategy:
      matrix:
        path:
     %{ for item in name ~}
     - ${item}
     %{ endfor ~}

    steps:
    - uses: dasmeta/reusable-actions-workflows/tflint@main
      with:
        aws-region: ${aws-region}
        aws-access-key-id: ${aws-access-key-id}
        aws-secret-access-key: ${aws-secret-access-key}
        path: modules/${path}
        repo-token: ${repo-token}
      continue-on-error: true
