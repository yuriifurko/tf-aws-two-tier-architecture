terraform {
  required_version = "1.8.0"

  backend "s3" {
    encrypt = true
    bucket  = "111111111111-terraform-dev"
    key     = "two-tier-architecture/terraform.tfstate"
    region  = "us-east-1"
    profile = "mng-administrator-access"

    assume_role = {
      role_arn = "arn:aws:iam::111111111111:role/terraform-execution-full-access"
    }
  }
}