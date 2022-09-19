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
 */

locals {
  branch_protections = var.enable_branch_protection && var.branch_protections != null ? var.branch_protections : {}

}

resource "github_repository" "this" {
  name               = var.name
  visibility         = "private"
  archive_on_destroy = true
}

resource "github_branch" "main" {
  count      = var.create_main_branch ? 1 : 0
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_branch_default" "default" {
  count = var.create_main_branch ? 1 : 0

  repository = github_repository.this.name
  branch     = github_branch.main[0].branch
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
    dismissal_restrictions = [
      data.github_team.admin_team.id
    ]
    require_code_owner_reviews = each.value["required_pull_request_reviews"]["require_code_owner_reviews"]
    required_approving_review_count = each.value["required_pull_request_reviews"]["required_approving_review_count"]
  }


}

