module "test" {
  source                      = "../"
  name                        = "terraform-github-actions-pipeline-resources-test-repo"
  tf_deps                     = module.s3-backend-dependencies
  allow_provisioning_services = ["sns"]
  branches_to_create          = ["dev", "test", "prod", "main"]
  enable_branch_protection    = false
  maintainer_team             = "product-infrastructure"
  depends_on                  = [aws_iam_openid_connect_provider.github_actions]
  archive_on_delete           = false
}
