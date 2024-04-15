locals {
  account_id = module.data.account_id
  region     = module.data.region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  project_name = "two-tier-arch"
  environment  = "dev"

  account_mapping = {
    mng  = 000000000000
    dev  = 111111111111
    qa   = 222222222222
    prod = 333333333333
  }

  tags = {
    Name        = local.project_name
    Environment = local.environment
    OwnerName   = "Yurii Furko"
    OwnerEmail  = "yurii.furko@gmail.com"
    ManagedBy   = "Terraform"
    Department  = "DevOps"
  }
}