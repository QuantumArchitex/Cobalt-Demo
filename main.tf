provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  tenant = var.tenant
  cidr_block = var.cidr_block
}

module "compute" {
  source           = "./modules/compute"
  tenant           = var.tenant
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_a_id
  instance_type    = var.instance_type
  public_key_path  = var.public_key_path
  ami_id           = var.ami_id
  key_name         = var.key_name
}

module "alb" {
  source        = "./modules/alb"
  tenant        = var.tenant
  vpc_id        = module.vpc.vpc_id
  subnet_ids     = [module.vpc.public_subnet_a_id, module.vpc.public_subnet_b_id]
  target_id     = module.compute.instance_id
  ssl_cert_arn  = module.ssl.cert_arn
}

# module "dns" {
#   source       = "./modules/dns"
#   tenant       = var.tenant
#   domain       = var.domain
#   alb_dns_name = module.alb.alb_dns_name
#   zone_id      = var.route53_zone_id
# }

module "ssl" {
  source = "./modules/ssl"
  domain = var.domain
  tenant = var.tenant
}
