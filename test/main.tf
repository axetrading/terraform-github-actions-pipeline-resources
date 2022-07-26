terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }

  required_version = ">= 1.2.0"
}

module "test" {
  source = "../"
  name = "test-name"
  tfstate_bucket_name = module.s3-backend-dependencies.tfstate_bucket_name
  tflocks_table_name = module.s3-backend-dependencies.tflocks_table_name
  allow_provisioning_services = [ "sns" ]
}
