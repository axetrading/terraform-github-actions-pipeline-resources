data "aws_iam_policy_document" "build_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "build" {
  name_prefix        = "${var.name}-build"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role_policy.json
}

resource "aws_iam_policy" "build" {
  name_prefix = "${var.name}-build"
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
      test     = "StringLike"
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
}

resource "aws_iam_role_policy_attachment" "build" {
  policy_arn = aws_iam_policy.build.arn
  role       = aws_iam_role.build.id
}
