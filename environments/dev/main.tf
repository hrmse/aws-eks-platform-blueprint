provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      environment = var.environment
      repository  = "aws-eks-platform-blueprint"
      owner       = var.owner
    }
  }
}

module "network" {
  source = "../../modules/network"

  name                 = "${var.name}-${var.environment}"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
}

module "eks" {
  source = "../../modules/eks"

  name                = "${var.name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
}
