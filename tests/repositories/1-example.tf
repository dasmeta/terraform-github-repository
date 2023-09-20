module "this" {
  source = "../../"
  # version = "0.8.0"

  defaults = {
    "license_template" : "apache-2.0",
    "tags" : ["terraform", "aws"],
    "homepage_url" : "www.dasmeta.com",
    "visibility" : "public"
  }

  repositories = [
    {
      "description" : "EKS module description",
      "name" : "terraform-aws-eks-test",
      "tags" : ["kubernetes", "aws", "cloudwatch", "eks"]
    },
    {
      "description" : "ELK module description",
      "name" : "terraform-aws-elasticache-test",
      "tags" : ["aws", "cloudwatch", "elk"]
    }
  ]
}
