terraform {
  # No backend for sandbox
}

provider "aws" {
  profile = var.aws_cli_profile
  region  = var.region
}