output "repo_url" {
  description = "URL of the repo"
  value       = github_repository.this.html_url
}

output "repo_name" {
  description = "Name of the repo"
  value       = github_repository.this.full_name
}

output "build_role_arn" {
  description = "ARN for the role to assume for the builds"
  value       = aws_iam_role.build.arn
}
