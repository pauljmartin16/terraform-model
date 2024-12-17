module "eks_al2023" {
  source = "terraform-aws-modules/eks/aws"
  #   version = "~> 20.0"

  cluster_name    = "${local.name}-al2023"
  cluster_version = "1.31"

  # EKS Addons
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

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  self_managed_node_groups = {
    my_self_managed_node_group = {
      ami_type      = "AL2023_x86_64_STANDARD"
      instance_type = "t3.small"
      capacity_type = "SPOT"

      min_size = 1
      max_size = 1
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1

      # This is not required - demonstrates how to pass additional configuration to nodeadm
      # Ref https://awslabs.github.io/amazon-eks-ami/nodeadm/doc/api/
      #   cloudinit_pre_nodeadm = [
      #     {
      #       content_type = "application/node.eks.aws"
      #       content      = <<-EOT
      #         ---
      #         apiVersion: node.eks.aws/v1alpha1
      #         kind: NodeConfig
      #         spec:
      #           kubelet:
      #             config:
      #               shutdownGracePeriod: 30s
      #               featureGates:
      #                 DisableKubeletCloudCredentialProviders: true
      #       EOT
      #     }
      #   ]
    }
  }

  tags = local.tags
}