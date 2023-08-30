/**
 * # GitHub Actions Pipeline Resources Terraform Module
 *
 * Resources to support a repo and pipeline in GitHub.
 * 
 * This module creates a GitHub repo with an AWS IAM Role that
 * an actions pipeline within the repo can assume. This is
 * achieved without having to manage any credentials. Auth for
 * assuming the role is achieved with GitHub's OIDC provider
 * and identity federation - see:
 *
 * https://github.com/aws-actions/configure-aws-credentials
 *
 * Note that you have to configure the GitHub organisation via
 * the `owner` GitHub provider config in the caller.
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
  }

  required_version = ">= 1.2.0"
}
