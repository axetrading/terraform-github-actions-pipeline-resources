data "aws_iam_policy_document" "build_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_oidc_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${github_repository.this.full_name}:*"]
    }
  }
}

resource "aws_iam_role" "build" {
  name               = "${var.name}-actions-build"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role_policy.json
}

resource "aws_iam_policy" "build" {
  name_prefix = "${var.name}-actions-build"
  policy      = data.aws_iam_policy_document.build.json
}

data "aws_dynamodb_table" "tflocks" {
  name = var.tflocks_table_name
}

data "aws_iam_policy_document" "build" {
  # permissions for using tfstate and tflocks
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${var.tfstate_bucket_name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${var.tfstate_bucket_name}/${var.name}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]
    resources = [data.aws_dynamodb_table.tflocks.arn]
    condition {
      test     = "ForAllValues:StringLike"
      variable = "dynamodb:LeadingKeys"
      values   = ["${var.tfstate_bucket_name}/${var.name}/*"]
    }
  }
  # permissions for provisioning resources
  statement {
    effect    = "Allow"
    actions   = formatlist("%s:*", var.allow_provisioning_services)
    resources = ["*"]
  }
  dynamic "statement" {
    for_each = length(var.assume_role_arns) > 0 ? [1] : []
    content {
      actions   = ["sts:AssumeRole"]
      resources = var.assume_role_arns
      effect    = "Allow"
    }
  }
}

resource "aws_iam_role_policy_attachment" "build" {
  policy_arn = aws_iam_policy.build.arn
  role       = aws_iam_role.build.id
}

resource "aws_iam_role_policy_attachment" "build_view_only" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  role       = aws_iam_role.build.id
}

resource "aws_iam_role_policy_attachment" "build_policy" {
  for_each   = toset(var.build_policy_arns)
  policy_arn = each.key
  role       = aws_iam_role.build.id
}
