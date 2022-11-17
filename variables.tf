variable "name" {
  type        = string
  description = "Name of the repo, used to name resources to make it easy to find the source"
}

variable "tf_deps" {
  type = object({
    tfstate_bucket_name = string
    tflocks_table_name  = string
  })
  description = "Terraform depdendencies - `tfstate_bucket_name` and `tflocks_table_name`"
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

variable "maintainer_team" {
  type        = string
  description = "Name of one team who maintains the pipeline."
}

variable "auto_init" {
  type        = bool
  default     = false
  description = "(Optional) Set to true to produce an initial commit in the repository."
}

variable "archive_on_delete" {
  type    = bool
  default = true
}

variable "environments" {
  type = map(object({
    role_arn = string
  }))
  default = {}
}
