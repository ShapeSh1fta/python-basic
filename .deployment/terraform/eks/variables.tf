variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.21"
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnets" {
  description = "The subnets where the EKS cluster will be deployed"
  type        = list(string)
}

variable "node_group_config" {
  description = "Configuration for EKS node groups"
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_type    = string
  }))
  default = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}
