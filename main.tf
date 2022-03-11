provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "3.12.0"
  name               = "eks_test_vpc"
  enable_nat_gateway = false
  single_nat_gateway = true
  cidr               = var.cidr
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"
  name = "eks-test-sg"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules       = ["http-80-tcp","ssh-tcp"]  
  egress_rules = [ "all-all" ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
  security_group_ids = [module.security-group.security_group_id]
  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    }
  }

  tags = {
    Project  = "Secret"
    Endpoint = "true"
  }
}