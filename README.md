AWS TWO-TIER-ARCHITECTURE
===

[![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/8723beef-8264-44c0-9e96-26b3d0f5f9c3/repos/c2bc1327-c4d7-485f-9c38-3e7312dfcb7d/branch/a72f35d6-693d-4acf-af6c-69885491cd0d/yuriyfRnD%252Ftf-aws-two-tier-architecture)](https://dashboard.infracost.io/org/yuriifurko/repos/c2bc1327-c4d7-485f-9c38-3e7312dfcb7d?tab=settings)

## 🏠 Architecture

![img](images/arch.drawio.png)

### Build and Verify docker container

```bash
docker run --rm -it $(docker build -q .) sh -c "whoami; pg_versions -v; git version"
```

### Infracost

[Sample](https://bitbucket.org/infracost/infracost-bitbucket-pipeline/src/master/)

```bash
# generate
infracost generate config --repo-path=. --template-path=infracost.yml.tmpl --out-file=infracost.yml

# breakdown
infracost breakdown --path . --usage-file=infracost.yml
infracost breakdown --config-file=infracost.yml --format=table --out-file=infracost-base.table
```

### Terraform Cloud

[Configuring Bitbucket Cloud Access](https://developer.hashicorp.com/terraform/cloud-docs/vcs/bitbucket-cloud)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.19.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.19.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-load-balancer.git | v1.0.0 |
| <a name="module_data"></a> [data](#module\_data) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-data-sources.git | v1.0.0 |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-ec2-service.git | v1.0.0 |
| <a name="module_frontent_security_group"></a> [frontent\_security\_group](#module\_frontent\_security\_group) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-security-group.git | v1.0.0 |
| <a name="module_route53"></a> [route53](#module\_route53) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-route53-records.git | v1.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::ssh://yurii-furko@bitbucket.org/yuriyfRnD/tf-aws-vpc-network.git | v1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.19.0/docs/data-sources/availability_zones) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/5.19.0/docs/data-sources/route53_zone) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/3.4.2/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->