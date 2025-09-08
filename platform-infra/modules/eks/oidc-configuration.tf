# OIDC provider for the EKS cluster
resource "aws_eks_identity_provider_config" "eks_oidc_provider" {
  cluster_name = aws_eks_cluster.eks_cluster_main.name
  oidc {
    identity_provider_config_name = "${var.environment}-${var.cluster_name}-oidc"
    issuer_url                     = aws_eks_cluster.eks_cluster_main.identity[0].oidc[0].issuer
    client_id                    = "sts.amazonaws.com"
  }
  # Ensure that the EKS cluster is created before the OIDC provider
  depends_on = [
    aws_eks_cluster.eks_cluster_main,
  ]

  tags = {
    Name = "${var.environment}-${var.cluster_name}-OIDC-Provider" # Name tag for the EKS cluster
  }
}