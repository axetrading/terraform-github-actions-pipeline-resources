/**
 * # GitHub Actions Pipeline Resources Terraform Module
 *
 * Resources to support a repo and pipeline in GitHub.
 * 
 * This module creates a GitHub repo with an AWS IAM Role that
 * an actions pipeline within the repo can assume. This is
 * achieved without having to manage any credentials. Auth for
 * assuming the role is achieved with GitHub's OIDC provider
 * and identity federation - see:
 *
 * https://github.com/aws-actions/configure-aws-credentials
 *
 * Note that you have to configure the GitHub organisation via
 * the `owner` GitHub provider config in the caller.
 *
 * To run the tests (don't currently test any behaviour, just
 * provisioning and destroying) you need to have a GITHUB_TOKEN
 * exported that's a PAT (Personal Access Token) with the
 * `repo` and `read:org` oauth scopes.
 *
 * Due to a bug (https://github.com/integrations/terraform-provider-github/issues/823)
 * you currently have to set the `GITHUB_OWNER` (owner) provider
 * config via an environment variable rather than as provider config in terraform.  
 */

locals {
  branches           = var.branches_to_create != [] && var.branches_to_create != null ? [for branch in var.branches_to_create : branch if branch != "main"] : []
  branch_protections = var.enable_branch_protection && var.branch_protections != null ? var.branch_protections : {}

}

resource "github_repository" "this" {
  name               = var.name
  visibility         = "private"
  archive_on_destroy = true
  auto_init          = var.auto_init
}

resource "github_branch" "this" {
  for_each   = toset(local.branches)
  repository = github_repository.this.name
  branch     = each.key
}

data "github_team" "admin_team" {
  slug = var.admin_team
}

resource "github_team_repository" "admin" {
  team_id    = data.github_team.admin_team.id
  repository = var.name
  permission = "admin"
}

resource "github_branch_protection" "main" {
  for_each = local.branch_protections

  repository_id = github_repository.this.name

  pattern          = each.value["pattern"]
  enforce_admins   = each.value["enforce_admins"]
  allows_deletions = each.value["allows_deletions"]

  required_status_checks {
    strict   = each.value["required_status_checks"]["strict"]
    contexts = each.value["required_status_checks"]["contexts"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = each.value["required_pull_request_reviews"]["dismiss_stale_reviews"]
    restrict_dismissals   = each.value["required_pull_request_reviews"]["restrict_dismissals"]
    dismissal_restrictions = flatten([
      data.github_team.admin_team.node_id
    , each.value["required_pull_request_reviews"]["dismissal_restrictions"]])
    require_code_owner_reviews      = each.value["required_pull_request_reviews"]["require_code_owner_reviews"]
    required_approving_review_count = each.value["required_pull_request_reviews"]["required_approving_review_count"]
  }


}

data "github_actions_public_key" "this" {
  repository = github_repository.this.name
}

resource "github_actions_secret" "role" {
  repository      = github_repository.this.name
  secret_name     = "ROLE_ARN"
  plaintext_value = aws_iam_role.build.arn
}
