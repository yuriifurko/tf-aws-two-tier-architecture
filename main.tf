module "data" {
  #source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-data-sources.git?ref=v1.0.0"
  source = "https://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-data-sources.git"
}

module "vpc" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-vpc-network.git?ref=v1.0.1"

  project_name = local.project_name
  environment  = local.environment

  region = module.data.region

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
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-load-balancer.git?ref=v1.0.0"

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
        format("%v/32", chomp(data.http.myip.response_body))
      ]
      "from_port" = 80
      "to_port"   = 80
      "protocol"  = "tcp"
    },
    "443" = {
      "description" = "Allow https ingress traffic"
      "cidrs" = [
        format("%v/32", chomp(data.http.myip.response_body))
      ]
      "from_port" = 443
      "to_port"   = 443
      "protocol"  = "tcp"
    }
  }

  tags = local.tags
}

module "frontent_security_group" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-security-group.git?ref=v1.0.0"

  project_name = local.project_name
  environment  = local.environment

  security_group_name        = format("%v-%v-%v", local.project_name, local.environment, "frontent")
  security_group_description = "Default frontend security group"

  vpc_id = module.vpc.vpc_id

  security_group_ingress_rules = {
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

  security_group_egress_rules = {
    "all" = {
      "description" = "Allow outbount access to the Internet"
      "cidrs" = [
        "0.0.0.0/0"
      ]
      "from_port" = 0
      "to_port"   = 0
      "protocol"  = "tcp"
    }
  }
}

module "ec2" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-ec2-service.git?ref=v1.0.0"

  project_name = local.project_name
  environment  = local.environment

  vpc_id = module.vpc.vpc_id

  cluster_enabled = true

  instance_ami  = module.data.ubuntu_20_04_amd64_ami_id
  instance_type = var.instance_type

  autoscaling_min_size = 2
  autoscaling_max_size = 2

  autoscaling_zone_identifier = module.vpc.vpc_private_subnets_id

  autoscaling_target_group_arns = [
    module.alb.lb_target_group_arn
  ]

  vpc_security_group_ids = [
    module.frontent_security_group.security_group_id
  ]

  user_data = base64encode(
    templatefile(format("%v/user-data/default.sh.tpl", path.module),
      {
        name = "Jonh Smith"
      }
    )
  )

  tags = local.tags

  depends_on = [
    module.vpc,
    module.alb
  ]
}

module "route53" {
  source = "git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-route53-records.git?ref=v1.0.0"

  route53_domain_name = data.aws_route53_zone.main.name

  route53_domain_records = {
    "two-tier" = {
      name   = "two-tier"
      type   = upper("cname")
      ttl    = 300
      record = module.alb.lb_dns_name
    }
  }
}