variable "name" {
  type        = string
  description = "Name of the repo, used to name resources to make it easy to find the source"
}

variable "tfstate_bucket_name" {
  type        = string
  description = "Bucket to store tfstate, in order to set up permissions"
}

variable "tflocks_table_name" {
  type        = string
  description = "DynamoDB table to use to lock Terraform state"
}

variable "allow_provisioning_services" {
  type        = list(string)
  description = "AWS service to add to the policy for provisioning (e.g. \"s3\")"
  default     = []
}

variable "assume_role_arns" {
  type        = list(string)
  description = "IAM Roles ARNs to allow the build role to assume"
  default     = []
}

variable "build_policy_arns" {
  type        = list(string)
  description = "IAM Policy ARNs to attach to the build role"
  default     = []
}

variable "admin_team" {
  type        = string
  description = "Name of one team to assign admin to - while it is possible to have mutliple teams with admin, our policy is to have one (it denotes responsibility of that team)."
}

variable "branch_protections" {
  type = map(object({
    pattern          = string
    enforce_admins   = bool
    allows_deletions = bool
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })
    required_pull_request_reviews = object({
      dismiss_stale_reviews           = bool
      restrict_dismissals             = bool
      dismissal_restrictions          = list(string)
      require_code_owner_reviews      = bool
      required_approving_review_count = number
    })
  }))
  description = "Map of branch protections that will be applied to github repo branches"
  default     = {}
}

variable "create_main_branch" {
  type        = bool
  description = "Create the main branch of your github repo."
  default     = true

}

variable "enable_branch_protection" {
  type        = bool
  default     = false
  description = "Enable Github Branch protections on your github repo."
}
