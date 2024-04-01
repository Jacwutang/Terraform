# Configure provider


# Configure VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
    value = module.vpc.private_subnets
}


module "eks" {
    source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access  = true

#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#   }

#   eks_managed_node_groups = {
#     example = {
#       min_size     = 1
#       max_size     = 1
#       desired_size = 1

#       instance_types = ["t3.large"]
#       capacity_type  = "SPOT"
#     }
#   }
}

