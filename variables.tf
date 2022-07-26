variable "name" {
    type = string
    description = "Name of the repo, used to name resources to make it easy to find the source"
}

variable "tfstate_bucket_name" {
    type = string
    description = "Bucket to store tfstate, in order to set up permissions"
}

variable "tflocks_table_name" {
    type = string
    description = "DynamoDB table to use to lock Terraform state"
}

variable "allow_provisioning_services" {
    type    = list
    description = "AWS service to add to the policy for provisioning (e.g. \"s3\")"
    default = []
}

variable "build_arns" {
    type    = list
    description = "CodeBuild build ARNs to allow the pipeline to run"
    default = []
}