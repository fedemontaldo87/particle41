# Check for correct workspace
data "local_file" "workspace_check" {
  count    = "${var.environment == terraform.workspace ? 0 : 1}"
  filename = "ERROR: Workspace does not match given environment name!"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                       = var.main_cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  assign_generated_ipv6_cidr_block = false

  tags = merge(
    {
      Name = "main",
    },
    var.tags,
  )
}
# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public1_cidr_block
#  availability_zone       = data.aws_availability_zones.available.names[0]
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name                        = "public-us-east-1a"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1
    },
    var.tags,
  )
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public2_cidr_block
#  availability_zone       = data.aws_availability_zones.available.names[0]
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name                        = "public-us-east-1b"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1
    },
    var.tags,
  )
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private1_cidr_block
  availability_zone = var.availability_zone1

  tags = merge(
    {
      Name                        = "private-us-east-1a"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1
    },
    var.tags,
  )
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private2_cidr_block
  availability_zone = var.availability_zone2

  tags = merge(
    {
      Name                        = "private-us-east-1b"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb"    = 1
    },
    var.tags,
  )
}