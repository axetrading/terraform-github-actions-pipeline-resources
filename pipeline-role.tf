/**
 * This file defines an IAM role used by the CodePipeline pipeline. It allows access to the CodeCommit
 * repository, artifacts bucket and CodeBuild builds.
 */

data "aws_iam_policy_document" "pipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pipeline" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role_policy.json
}

resource "aws_iam_policy" "pipeline" {
  name_prefix = "${var.name}-pipeline"
  policy      = data.aws_iam_policy_document.pipeline.json
}

data "aws_iam_policy_document" "pipeline" {
  statement {
    actions = [
      # https://docs.aws.amazon.com/codecommit/latest/userguide/auth-and-access-control-permissions-reference.html#aa-acp
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive",
    ]
    resources = [aws_codecommit_repository.repo.arn]
    effect    = "Allow"
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [aws_s3_bucket.artifacts.arn]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.artifacts.arn}/*"]
    effect    = "Allow"
  }
  dynamic "statement" {
    for_each = length(var.build_arns) > 0 ? [1] : []
    content {
      actions   = ["codebuild:StartBuild", "codebuild:Batch*"]
      resources = var.build_arns
      effect    = "Allow"
    }
  }
}

resource "aws_iam_role_policy_attachment" "pipeline" {
  policy_arn = aws_iam_policy.pipeline.arn
  role       = aws_iam_role.pipeline.id
}
