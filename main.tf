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

resource "github_repository" "this" {
  name               = var.name
  visibility         = "private"
  archive_on_destroy = true
}

data "github_team" "admin_team" {
  slug = var.admin_team
}

resource "github_team_repository" "admin" {
  team_id    = data.github_team.admin_team.id
  repository = var.name
  permission = "admin"
}
