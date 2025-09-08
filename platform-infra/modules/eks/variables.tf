variable "cluster_name" {
  description = "Provides the name of the EKS cluster"
  type        = string
  default     = "mini-idp-eks-cluster"

  #example
  #cluster_name = "my-eks-cluster"
}

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

variable "cluster_version" {
  description = "Provides the Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"

  #Example: "1.33"
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnet in availability zone 1&2"
  type        = list(string)

  #Example: "subnet-0bb1c79de3EXAMPLE"
}

variable "public_subnet_ids" {
  description = "The ID of the public subnet in availability zone 1 & 2"
  type        = list(string)

  #Example: "subnet-0bb1c79de3EXAMPLE"
}