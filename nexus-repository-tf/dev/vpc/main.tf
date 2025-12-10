resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nexus-repository-vpc-nat-eip"
    Env  = var.env
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  name = "nexus-repository-vpc"
  cidr = var.vpc_cidr

  azs             = [var.az1]
  private_subnets = [var.private_subnet1_cidr]
  public_subnets  = [var.public_subnet1_cidr]

  enable_dns_hostnames   = true
  enable_dns_support     = true
  single_nat_gateway     = true
  enable_nat_gateway     = true
  reuse_nat_ips          = true
  one_nat_gateway_per_az = false
  external_nat_ip_ids    = [aws_eip.nat.id]

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
