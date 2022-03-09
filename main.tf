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

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
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