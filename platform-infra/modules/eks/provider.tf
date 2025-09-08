terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
  }
}

# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}