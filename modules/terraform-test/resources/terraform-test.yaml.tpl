name: Terraform Test
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
    runs-on: ubuntu-latest
    strategy:
      matrix:
        path:
     %{ for item in paths ~}
     - ${item}
     %{ endfor ~}

    steps:
    - uses: dasmeta/reusable-actions-workflows/terraform-test@4.1.1
      with:
        aws-region: ${aws-region}
        aws-access-key-id: ${aws-access-key-id}
        aws-secret-access-key: ${aws-secret-access-key}
        path: ${path}
      continue-on-error: true
