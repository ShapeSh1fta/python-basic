module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  subnets         = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
  vpc_id          = "vpc-zzzzzzzz"
  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t3.medium"
    }
  }
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}
