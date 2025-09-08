# Create the Internet Gateway for public access
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_main.id # VPC ID to associate the Internet Gateway with
  tags = {
    Name = "${var.environment}-${var.igw_name}" # Name tag for the Internet Gateway
  }
}

# Create the route table for the subnet
resource "aws_route_table" "public_route_tbl_az1" {
  vpc_id = aws_vpc.vpc_main.id # VPC ID to associate the route table with

  # # Route for internal traffic
  # route {
  #   cidr_block = var.public_subnet_cidr_block1
  #   gateway_id = "local"
  # }

  # Route for external traffic
  route {
    cidr_block = "0.0.0.0/0"                     # Allow all public traffic
    gateway_id = aws_internet_gateway.vpc_igw.id # Route public access through the Internet Gateway
  }

  tags = {
    Name = "${var.environment}-public-route-tbl-az1" # Name tag for the route table
  }
}

# Create the route table for the subnet
resource "aws_route_table" "public_route_tbl_az2" {
  vpc_id = aws_vpc.vpc_main.id # VPC ID to associate the route table with

  # # Route for internal traffic
  # route {
  #   cidr_block = var.public_subnet_cidr_block2
  #   gateway_id = "local"
  # }

  # Route for external traffic
  route {
    cidr_block = "0.0.0.0/0"                     # Allow all public traffic
    gateway_id = aws_internet_gateway.vpc_igw.id # Route public access through the Internet Gateway
  }

  tags = {
    Name = "${var.environment}-public-route-tbl-az2" # Name tag for the route table
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "route_tbl_ass_az1" {
  subnet_id      = aws_subnet.public_vpc_subnet_az1.id     # Subnet ID to associate the route table with
  route_table_id = aws_route_table.public_route_tbl_az1.id # Route table ID to associate with the subnet
}

# Associate the route table with the subnet
resource "aws_route_table_association" "route_tbl_ass_az2" {
  subnet_id      = aws_subnet.public_vpc_subnet_az2.id     # Subnet ID to associate the route table with
  route_table_id = aws_route_table.public_route_tbl_az2.id # Route table ID to associate with the subnet
}