# Provider config
profile     = "default"   # AWS profile https://amzn.to/2IgHGCs
region      = "us-east-1" # See regions of AWS https://amzn.to/3khGP21
environment = "testing"

# General
# If not existis, create a public and private key with command:
# sudo ssh-keygen -t rsa -b 2048 -v -f /home/aws-testing.pem
# Do not enter a password when creating the keys
#
# The public key will be created in the following path: '/home/aws-testing.pem.pub'
# and will be registered on AWS under the name 'aws-testing'. This public key will
# be associated with the EC2 instances during the creation of the cluster and this
# way you will be able to access them via SSH in the future using the private key
# that is in '/home/aws-testing.pem'.
aws_public_key_path        = "/home/aws-testing.pem.pub"
aws_key_name               = "aws-testing"
address_allowed            = "181.46.71.195/32" # My house public IP Address
bucket_name                = "terraform-state-particle41"
dynamodb_table_name        = "dynamodb-terraform-state-lock"
main_cidr_block            = "192.168.0.0/16"
subnet_public1_cidr_block  = "192.168.0.0/18"
subnet_public2_cidr_block  = "192.168.64.0/18"
subnet_private1_cidr_block = "192.168.128.0/18"
subnet_private2_cidr_block = "192.168.192.0/18"

tags = {
  Terraform   = "true",
  Environment = "testing"
}