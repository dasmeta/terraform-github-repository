# Verifies the module plans cleanly for a multi-repository catalog where each
# entry overrides topics and one entry configures pages, exercising the
# defaults-merge logic across more than one repository.
#
# A successful plan is the assertion; see tests/basic-create.tftest.hcl.
#
# Requires GITHUB_TOKEN for the github provider.

provider "github" {
  owner = "dasmeta"
}

variables {
  defaults = {
    license_template = "apache-2.0"
    topics           = ["terraform", "aws"]
    homepage_url     = "www.dasmeta.com"
    visibility       = "public"
  }

  repositories = [
    {
      name        = "terraform-aws-mongodb-backup"
      description = "EKS module description"
      topics      = ["kubernetes", "aws", "cloudwatch", "eks"]
      pages = {
        branch = "gh-pages"
        path   = "/"
      }
    },
    {
      name        = "terraform-aws-elasticache-test"
      description = "ELK module description"
      topics      = ["aws", "cloudwatch", "elk"]
    }
  ]
}

run "repositories_plans_cleanly" {
  command = plan
}
