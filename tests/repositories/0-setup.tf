terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.39.0"
    }
  }

  required_version = ">= 1.3.0"
}

/**
 *set GITHUB_TOKEN env variable for github provider setup:

 export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxx
**/
provider "github" {
  owner = "dasmeta"
}
