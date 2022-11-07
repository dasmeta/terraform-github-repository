name: Checkov
on:
  pull_request:
  push:
    branches: [main, master]
jobs:
  terraform-validate:
    runs-on: ubuntu-latest
    permissions: write-all
    strategy:
      matrix:
        path:
     %{ for item in name ~}
     - ${item}
     %{ endfor ~}

    steps:
    - uses: dasmeta/reusable-actions-workflows/checkov@main
      with:
        fetch-depth: 0
        directory: modules/${path}
      continue-on-error: true
