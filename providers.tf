provider "aws" {
  region  = "us-east-1"
  profile = "administrator-access-935454902317"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}