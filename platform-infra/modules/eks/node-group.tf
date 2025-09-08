resource "aws_eks_node_group" "eks_node_group_main" {
  cluster_name    = aws_eks_cluster.eks_cluster_main.name               # Reference to the EKS cluster name
  node_group_name = "${var.environment}-${var.cluster_name}-node-group" # Naming convention for the node group
  node_role_arn   = aws_iam_role.nodes_IAMRole.arn
  subnet_ids      = aws_subnet.example[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    # This setting prevents Terraform from modifying the desired_size of the node group after its initial creation.
    # This is useful in scenarios where the desired_size might be changed outside of Terraform 
    # e.g., via the AWS Management Console or autoscaling policies.
    ignore_changes = [ scaling_config[0].desired_size ]
  }

  tags = {
    Name = "${var.environment}-${var.cluster_name}-node-group" # Name tag for the EKS node group
  }
}