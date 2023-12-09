module "data" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-data-sources.git?ref=master"
}

module "vpc" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-vpc-network.git?ref=v1.0.1"

  project_name = local.project_name
  environment  = local.environment
  region       = local.region

  vpc_cidr            = local.vpc_cidr
  availability_zones  = local.azs
  nat_gateway_enabled = true

  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  public_subnet_tags  = local.tags
  private_subnet_tags = local.tags

  tags = local.tags
}

module "alb" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-load-balancer.git?ref=master"

  project_name = local.project_name
  environment  = local.environment

  load_balancer_type = "application"
  ssl_policy         = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn    = "arn:aws:acm:us-east-1:935454902317:certificate/715ffc27-2870-4ac7-843b-826819fb6d31"

  load_balancer_is_internal  = false
  enable_deletion_protection = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.vpc_public_subnets_id

  security_group_ingress_cidr_blocks = {
    "80" = {
      "description" = "Allow http ingress traffic"
      "cidrs" = [
        "0.0.0.0/0"
      ]
      "from_port" = 80
      "to_port"   = 80
      "protocol"  = "tcp"
    },
    "443" = {
      "description" = "Allow https ingress traffic"
      "cidrs" = [
        "0.0.0.0/0"
      ]
      "from_port" = 443
      "to_port"   = 443
      "protocol"  = "tcp"
    }
  }

  tags = local.tags
}

module "ec2" {
  #source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-ec2-service.git?ref=master"
  source = "/Users/yuriifurko/Documents/Cloud/aws/tf-aws-ec2-service"

  project_name = local.project_name
  environment  = local.environment
  region       = local.region

  vpc_id = module.vpc.vpc_id

  cluster_enabled   = true
  instance_ami      = module.data.ubuntu_20_04_amd64_ami_id
  instance_type     = "t3a.small"

  autoscaling_min_size = "2"
  autoscaling_max_size = "2"

  autoscaling_zone_identifier   = module.vpc.vpc_private_subnets_id
  autoscaling_target_group_arns = [module.alb.lb_target_group_arn]

  security_group_ingress_cidr_blocks = {
    "80" = {
      "description" = "Allow http ingress traffic from alb"
      "cidrs" = [
        "0.0.0.0/0"
      ]
      "from_port" = 80
      "to_port"   = 80
      "protocol"  = "tcp"
    }
  }

  user_data = base64encode(templatefile("${path.module}/user-data/default.sh.tpl", {}))

  tags = local.tags

  depends_on = [
    module.vpc,
    module.alb
  ]
}


module "route53" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-route53-records.git?ref=master"

  route53_domain_name = "dev.awsworkshop.info"

  route53_domain_records = {
    "two-tier" = {
      name   = "two-tier"
      type   = upper("cname")
      ttl    = 300
      record = module.alb.lb_dns_name
    }
  }
}