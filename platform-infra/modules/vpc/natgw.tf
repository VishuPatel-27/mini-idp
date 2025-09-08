resource "aws_eip" "nat_gw_eip" {
  tags = {
    Name = "${var.environment}-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id               # Allocate the Elastic IP to the NAT Gateway
  subnet_id     = aws_subnet.public_vpc_subnet_az2.id # Ensure the NAT Gateway is in a public subnet

  tags = {
    Name = "${var.environment}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.vpc_igw]
}