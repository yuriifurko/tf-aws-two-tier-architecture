locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  project_name = "two-tier-arch"
  environment  = "dev"

  tags = {
    Name          = local.project_name
    Environment   = local.environment
    OwnerFullName = "Yurii Furko"
    OwnerEmail    = "yurii.furko@gmail.com"
    ManagedBy     = "Terraform"
    Department    = "DevOps"
  }
}