resource "aws_iam_role" "nodes_IAMRole" {

  name = "${var.environment}-${var.cluster_name}-nodes-IAMRole" # Naming convention for the IAM role
  # Path to the trust policy document that grants an entity permission to assume the role
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

#This policy enables the kubelet, which runs on the EC2 instances that serve as worker nodes, 
#to access and manage EC2 resources, use container images from Amazon Elastic Container Registry (ECR), 
#and also provides permissions for the EKS Pod Identity Agent
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_IAMRole.name
}

#CNI is responsible for enabling native Amazon Virtual Private Cloud (VPC) networking for pods running on 
#EKS worker nodes.
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_IAMRole.name
}

#This policy allows the worker nodes to pull container images from Amazon ECR
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_IAMRole.name
}