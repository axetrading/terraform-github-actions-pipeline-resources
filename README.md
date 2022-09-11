<!-- BEGIN_TF_DOCS -->
# GitHub Actions Pipeline Resources Terraform Module

Resources to support a repo and pipeline in GitHub.

This module creates a GitHub repo with an AWS IAM Role that
an actions pipeline within the repo can assume. This is
achieved without having to manage any credentials. Auth for
assuming the role is achieved with GitHub's OIDC provider
and identity federation - see:

https://github.com/aws-actions/configure-aws-credentials

Note that you have to configure the GitHub organisation via
the `owner` GitHub provider config in the caller.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.22 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.25.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.build](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.build](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.build](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.build_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.build_view_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_dynamodb_table.tflocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/dynamodb_table) | data source |
| [aws_iam_openid_connect_provider.github_oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.build](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.build_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_provisioning_services"></a> [allow\_provisioning\_services](#input\_allow\_provisioning\_services) | AWS service to add to the policy for provisioning (e.g. "s3") | `list(string)` | `[]` | no |
| <a name="input_assume_role_arns"></a> [assume\_role\_arns](#input\_assume\_role\_arns) | IAM Roles ARNs to allow the build role to assume | `list(string)` | `[]` | no |
| <a name="input_build_arns"></a> [build\_arns](#input\_build\_arns) | CodeBuild build ARNs to allow the pipeline to run | `list(string)` | `[]` | no |
| <a name="input_build_policy_arns"></a> [build\_policy\_arns](#input\_build\_policy\_arns) | IAM Policy ARNs to attach to the build role | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the repo, used to name resources to make it easy to find the source | `string` | n/a | yes |
| <a name="input_tflocks_table_name"></a> [tflocks\_table\_name](#input\_tflocks\_table\_name) | DynamoDB table to use to lock Terraform state | `string` | n/a | yes |
| <a name="input_tfstate_bucket_name"></a> [tfstate\_bucket\_name](#input\_tfstate\_bucket\_name) | Bucket to store tfstate, in order to set up permissions | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_role_arn"></a> [build\_role\_arn](#output\_build\_role\_arn) | ARN for the role to assume for the builds |
| <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name) | Name of the repo |
| <a name="output_repo_url"></a> [repo\_url](#output\_repo\_url) | URL of the repo |
<!-- END_TF_DOCS -->