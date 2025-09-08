# Create the VPC
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.cidr_block # CIDR block for the VPC
  instance_tenancy = "default"      # Default instance tenancy

  # Enable DNS support and hostnames
  # These settings are often required for proper functionality of AWS services within the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-${var.vpc_name}" # Name tag for the VPC
  }
}