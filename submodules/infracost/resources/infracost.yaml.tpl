name: Infracost
on:
  pull_request:
  push:
    branches: [main, master]
jobs:
  terraform-validate:
    runs-on: ubuntu-latest
    permissions:
      actions: write
      contents: write
      discussions: write
      pull-requests: write
      security-events: write
      id-token: write
    strategy:
      matrix:
        path:
     %{ for item in name ~}
     - ${item}
     %{ endfor ~}

    steps:
      - name: Setup Infracost
        uses: infracost/actions/setup@v2
        with:
           api-key: ${secret}

      - name: Checkout base branch
        uses: actions/checkout@v3
        with:
          ref: ${ref}

      - name: Generate Infracost cost estimate baseline
        run: |
          infracost breakdown --path=modules/${path} \
                              --format=json \
                              --out-file=/tmp/infracost-base.json
        continue-on-error: true

      - name: Checkout PR branch
        uses: actions/checkout@v3

      - name: Generate Infracost diff
        run: |
          infracost diff --path=modules/${path}\
                          --format=json \
                          --compare-to=/tmp/infracost-base.json \
                          --out-file=/tmp/infracost.json
        continue-on-error: true

      - name: Post Infracost comment
        run: |
            infracost comment github --path=/tmp/infracost.json \
                                     --repo=$GITHUB_REPOSITORY \
                                     --github-token=${token} \
                                     --pull-request=${pr} \
                                     --behavior=update
        continue-on-error: true
