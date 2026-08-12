module "this" {
  source = "../../"

  defaults = {
    "license_template" : "apache-2.0",
    "topics" : ["terraform", "aws"],
    "homepage_url" : "www.dasmeta.com",
    "visibility" : "public"
  }

  repositories = [
    {
      "description" : "EKS module description",
      "name" : "terraform-aws-mongodb-backup",
      "topics" : ["kubernetes", "aws", "cloudwatch", "eks"],
      "pages" : {
        "branch" : "gh-pages"
        "path" : "/"
      }
    },
    {
      "description" : "ELK module description",
      "name" : "terraform-aws-elasticache-test",
      "topics" : ["aws", "cloudwatch", "elk"]
    }
  ]
}
