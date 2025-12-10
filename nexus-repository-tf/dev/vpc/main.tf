# resource "aws_eip" "nat" {
#   domain = "vpc"

#   tags = {
#     Name = "nexus-repository-vpc-nat-eip"
#     Env  = var.env
#   }
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  name = "nexus-repository-vpc"
  cidr = var.vpc_cidr

  azs             = [var.az1]
  private_subnets = [var.private_subnet1_cidr]
  public_subnets  = [var.public_subnet1_cidr]

  enable_dns_hostnames   = false
  enable_dns_support     = false
  single_nat_gateway     = false
  enable_nat_gateway     = false
  reuse_nat_ips          = false
  one_nat_gateway_per_az = false
  external_nat_ip_ids    = []

  map_public_ip_on_launch = true

  private_subnet_tags = {
    Name = "nexus-repository-private-subnet"
    Env  = var.env
  }

  public_subnet_tags = {
    Name = "nexus-repository-public-subnet"
    Env  = var.env
  }

  tags = {
    Env = var.env
  }
}
