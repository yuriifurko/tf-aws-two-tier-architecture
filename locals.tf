locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  project_name = "two-tier-arch"
  environment  = "dev"
  profile      = "administrator-access-935454902317"
  eks_version  = "1.26"

  domain_name = format("%v.%v", local.environment, "dev.awsworkshop.info")

  tags = {
    Name          = "two-tier-arch"
    Environment   = "dev"
    OwnerFullName = "Yurii Furko"
    OwnerEmail    = "yurii.furko@gmail.com"
    ManagedBy     = "Terraform"
    Department    = "DevOps"
  }
}