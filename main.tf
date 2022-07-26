/**
 * # Pipeline Resources Terraform Module
 *
 * Resources to support a AWS CodePipeline.
 *
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }

  required_version = ">= 1.2.0"
}