module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # version = "~> 20.0"

  cluster_name    = "${local.name}-al2023"
  cluster_version = "1.31"

  # bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups = {
    my_eks_managed_node_group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  tags = local.tags
}