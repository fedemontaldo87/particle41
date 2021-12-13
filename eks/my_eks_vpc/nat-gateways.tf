# Resource: aws_nat_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat1.id
  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.public_1.id
  # A map of tags to assign to the resource.
  tags = {
    Name = "NAT 1"
  }
}
resource "aws_nat_gateway" "gw2" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat2.id
  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.public_2.id
  # A map of tags to assign to the resource.
  tags = {
    Name = "NAT 2"
  }
}

# Resource: aws_eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat1" {
  # EIP may require IGW to exist prior to association. 
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.main]
}
resource "aws_eip" "nat2" {
  # EIP may require IGW to exist prior to association. 
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.main]
}