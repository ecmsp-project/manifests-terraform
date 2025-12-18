resource "aws_iam_role" "eks" {
  name = "${var.env}-${var.eks_cluster_name}-eks-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-${var.eks_cluster_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

resource "aws_eks_access_entry" "root_account" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = "arn:aws:iam::529236942244:root"
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "root_account_admin" {
  cluster_name       = aws_eks_cluster.eks.name
  policy_arn         = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn      = "arn:aws:iam::529236942244:root"
  access_scope {
    type = "cluster"
  }
}