output "repo_url" {
  description = "git-remote-codecommmit URL for the repo"
  value = "codecommit::${data.aws_region.current.name}://${var.name}"
}

output "repo_name" {
  description = "Name of the repo"
  value = var.name
}

output "pipeline_role_arn" {
  description = "ARN for the role to attach to the CodePipeline, allowing access ot the artifacts bucket, CodeCommit repo and CodeBuild builds."
  value = aws_iam_role.pipeline.arn
}

output "build_role_arn" {
  description = "ARN for the role to assume for the builds"
  value = aws_iam_role.build.arn
}

output "artifacts_bucket_name" {
  description = "Name of the bucket for the pipeline to store artifacts."
  value = aws_s3_bucket.artifacts.id
}