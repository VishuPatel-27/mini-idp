# Create the VPC subnet
resource "aws_subnet" "public_vpc_subnet_az1" {
  vpc_id                  = aws_vpc.vpc_main.id           # VPC ID to associate the subnet with
  cidr_block              = var.public_subnet_cidr_block1 # CIDR block for the subnet
  availability_zone       = "${var.region}a"              # Availability zone for the subnet
  map_public_ip_on_launch = true                          # Assign public IP to instances launched in this subnet
  tags = {
    Name = "${var.environment}-public-subnet-az1" # Name tag for the subnet
    #kubernetes.io/role/elb = "1" # Tag for k8s load balancer
  }
}

resource "aws_subnet" "public_vpc_subnet_az2" {
  vpc_id                  = aws_vpc.vpc_main.id           # VPC ID to associate the subnet with
  cidr_block              = var.public_subnet_cidr_block2 # CIDR block for the subnet
  availability_zone       = "${var.region}b"              # Availability zone for the subnet
  map_public_ip_on_launch = true                          # Assign public IP to instances launched in this subnet
  tags = {
    Name = "${var.environment}-public-subnet-az2" # Name tag for the subnet
    #kubernetes.io/role/elb = "1" # Tag for k8s load balancer
  }
}

resource "aws_subnet" "private_vpc_subnet_az1" {
  vpc_id                  = aws_vpc.vpc_main.id            # VPC ID to associate the subnet with
  cidr_block              = var.private_subnet_cidr_block1 # CIDR block for the subnet
  availability_zone       = "${var.region}a"               # Availability zone for the subnet
  tags = {
    Name = "${var.environment}-private-subnet-az1" # Name tag for the subnet
    #kubernetes.io/role/internal-elb = "1" # Tag for k8s load balancer
  }
}

resource "aws_subnet" "private_vpc_subnet_az2" {
  vpc_id                  = aws_vpc.vpc_main.id            # VPC ID to associate the subnet with
  cidr_block              = var.private_subnet_cidr_block2 # CIDR block for the subnet
  availability_zone       = "${var.region}b"               # Availability zone for the subnet
  tags = {
    Name = "${var.environment}-private-subnet-az2" # Name tag for the subnet
    #kubernetes.io/role/internal-elb = "1" # Tag for k8s load balancer
  }
}