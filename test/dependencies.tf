module "s3-backend-dependencies" {
  source = "git@github.com:axetrading/terraform-axetrading-s3-backend-dependencies.git?ref=v2.1.0"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}
