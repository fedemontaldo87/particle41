# Terraform backend for remote state
terraform {
  backend "s3" {
    encrypt                 = true
    bucket                  = "terraform-state-particle41"
    dynamodb_table          = "dynamodb-terraform-state-lock"
    region                  = "us-east-1"
    workspace_key_prefix    = "testing"
    key                     = "eks/terraform.tfstate"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}