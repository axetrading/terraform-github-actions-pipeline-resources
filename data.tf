data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "github_oidc_provider" {
  url = "https://token.actions.githubusercontent.com"
}
