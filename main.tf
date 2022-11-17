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
  archive_on_destroy = var.archive_on_delete
  auto_init          = var.auto_init
}

data "github_team" "maintainer_team" {
  slug = var.maintainer_team
}

resource "github_team_repository" "maintainer" {
  team_id    = data.github_team.maintainer_team.id
  repository = var.name
  permission = "maintain"
}

data "github_actions_public_key" "this" {
  depends_on = [
    github_repository.this
  ]
  repository = github_repository.this.name
}

resource "github_actions_secret" "role" {
  depends_on = [
    github_repository.this
  ]
  repository      = github_repository.this.name
  secret_name     = "ROLE_ARN"
  plaintext_value = aws_iam_role.build.arn
}

resource "null_resource" "environments" {
  for_each = var.environments
  triggers = {
    owner      = "axetrading"
    name       = each.key
    repository = github_repository.this.name
  }

  provisioner "local-exec" {
    command = <<END
        curl \
            --silent \
            --show-error \
            --fail-with-body \
            --location \
            --header "Accept: application/vnd.github+json" \
            --header "Authorization: Bearer $GITHUB_TOKEN" \
            --request PUT \
            --data-binary '{}' \
            https://api.github.com/repos/${self.triggers.owner}/${self.triggers.repository}/environments/${self.triggers.name}
END
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<END
        curl \
            --silent \
            --show-error \
            --fail-with-body \
            --location \
            --header "Accept: application/vnd.github+json" \
            --header "Authorization: Bearer $GITHUB_TOKEN" \
            --request DELETE \
            https://api.github.com/repos/${self.triggers.owner}/${self.triggers.repository}/environments/${self.triggers.name} 
END
  }
}

resource "github_actions_environment_secret" "this" {
  for_each        = var.environments
  repository      = github_repository.this.name
  environment     = each.key
  secret_name     = "ASSUME_ROLE_ARN"
  plaintext_value = each.value.role_arn
  depends_on      = [github_repository.this, null_resource.environments]
}
