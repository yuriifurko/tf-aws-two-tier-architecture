locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  project_name = "two-tier-arch"
  environment  = "dev"

  tags = {
    Name          = "two-tier-arch"
    Environment   = "dev"
    OwnerFullName = "Yurii Furko"
    OwnerEmail    = "yurii.furko@gmail.com"
    ManagedBy     = "Terraform"
    Department    = "DevOps"
  }
}