module "test" {
  source                      = "../"
  name                        = "test-name"
  tfstate_bucket_name         = module.s3-backend-dependencies.tfstate_bucket_name
  tflocks_table_name          = module.s3-backend-dependencies.tflocks_table_name
  allow_provisioning_services = ["sns"]
  create_branch               = true
  branches_to_create          = ["dev", "test", "prod", "main"]
  enable_branch_protection    = false
  admin_team                  = "product-infrastructure"
  depends_on                  = [aws_iam_openid_connect_provider.github_actions]
}
