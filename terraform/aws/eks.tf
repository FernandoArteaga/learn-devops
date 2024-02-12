resource "aws_eks_cluster" "main" {
  name     = var.k8s_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = concat(
      aws_subnet.public_subnet[*].id,
      aws_subnet.private_subnet[*].id
    )
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet,
  ]
}

# Nodes in private subnets
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = aws_subnet.private_subnet[*].id

  instance_types = ["t2.micro"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  taint {
    key    = "vm-size"
    value  = "tiny"
    effect = "NO_SCHEDULE"
  }

  tags = merge(var.tags, { subnet = "private" })

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}

# Nodes in public subnet
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "public-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = aws_subnet.public_subnet[*].id

  instance_types = ["t2.micro"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  taint {
    key    = "vm-size"
    value  = "tiny"
    effect = "NO_SCHEDULE"
  }

  tags = merge(var.tags, { subnet = "public" })

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}
