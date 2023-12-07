module "vpc" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-vpc-network.git?ref=master"

  project_name = local.project_name
  environment  = local.environment
  profile      = local.profile
  region       = local.region

  vpc_cidr            = local.vpc_cidr
  availability_zones  = local.azs
  nat_gateway_enabled = true

  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    "kubernetes.io/cluster/${local.project_name}-${local.environment}" = "owned"
    "kubernetes.io/cluster/${local.project_name}-${local.environment}" = "shared"
  }
}