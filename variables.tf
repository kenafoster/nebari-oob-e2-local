# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------


variable "my_local_ip" {
  description = "Public IP address where the user is working (for opening up security groups)."
  type        = string
}

variable "my_key_pair" {
  description = "ID of the key pair for use in Nebari EC2 (create and update .tfvars before running Terraform)."
  type        = string
}

variable "account_id" {
  description = "The AWS account where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The AWS region where all resources will be launched."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------


variable "nebari_ec2_size" {
  description = "Set instance size for Nebari sandbox"
  type        = string
  default     = "t3.large"
}

variable "nebari_disk_size" {
  description = "Set root disk size for Nebari sandbox (in GiB)"
  type        = string
  default     = "16"
}

variable "aws_cli_profile" {
  description = "Configure AWS CLI profile to use (if not default)."
  type        = string
  default     = "default"
}