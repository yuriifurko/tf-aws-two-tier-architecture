data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "main" {
  name = "dev.awsworkshop.info"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"

  request_headers = {
    Accept = "application/json"
  }
}