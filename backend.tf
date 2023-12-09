terraform {
  required_version = ">= 0.14.11"

  backend "s3" {
    encrypt = true
    bucket  = "935454902317-terraform-dev"
    key     = "two-tier-architecture/terraform.tfstate"
    region  = "us-east-1"
    profile = "administrator-access-935454902317"
  }
}