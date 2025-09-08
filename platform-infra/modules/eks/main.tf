resource "aws_eks_cluster" "eks_cluster_main" {
  name = "${var.environment}-${var.cluster_name}" # Naming convention for the EKS cluster

  # Configuartion for accessing the cluster 
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # The IAM role that provides permissions for the EKS cluster to make AWS API calls
  role_arn = aws_iam_role.cluster_IAMRole.arn
  version  = var.cluster_version # Kubernetes version for the EKS cluster

  vpc_config {

    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]] # Subnet IDs for the EKS cluster
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = {
    Name = "${var.environment}-${var.cluster_name}" # Name tag for the EKS cluster
  }
}