variable "region" {
  type        = string
  description = "AWS region where resources will be created"

  # example
  # region = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment for resource deployment"

  # example
  # environment = "dev"
}

variable "cidr_block" {
  type        = string
  description = "this variable holds the value of CIDR block"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "public_subnet_cidr_block1" {
  type        = string
  description = "this variable holds the value of CIDR block for subnet"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "public_subnet_cidr_block2" {
  type        = string
  description = "this variable holds the value of CIDR block for subnet"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "private_subnet_cidr_block1" {
  type        = string
  description = "this variable holds the value of CIDR block for subnet"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "private_subnet_cidr_block2" {
  type        = string
  description = "this variable holds the value of CIDR block for subnet"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "vpc_name" {
  type        = string
  description = "name of your VPC"
}

variable "public_subnet_name1" {
  type        = string
  description = "name of your subnet which is associated to the VPC we created"
}

variable "public_subnet_name2" {
  type        = string
  description = "name of your subnet which is associated to the VPC we created"
}

variable "private_subnet_name1" {
  type        = string
  description = "name of your subnet which is associated to the VPC we created"
}

variable "private_subnet_name2" {
  type        = string
  description = "name of your subnet which is associated to the VPC we created"
}

variable "igw_name" {
  type        = string
  description = "name of your internet gateway"
}

variable "natgw_name" {
  type        = string
  description = "name of your internet gateway"
}
