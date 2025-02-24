provider "aws" {
  region  = "us-east-1"
  profile = "mng-administrator-access"

  skip_credentials_validation = true
  skip_requesting_account_id  = true

  assume_role {
    role_arn = "arn:aws:iam::${lookup(local.account_mapping, local.environment)}:role/terraform-execution-full-access"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}