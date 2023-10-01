# Configure the AWS Provider
provider "aws" {
  region  = var.region
}


# Create VPC
module "vpc" {
  source                = "../modules/vpc"
  vpc-cidr-block        = var.vpc-cidr-block
  pub-sub-1-cidr-block  = var.pub-sub-1-cidr-block
  pub-sub-2-cidr-block  = var.pub-sub-2-cidr-block
  priv-sub-1-cidr-block = var.priv-sub-1-cidr-block
  priv-sub-2-cidr-block = var.priv-sub-2-cidr-block
  region                = var.region

}

# Create ECS
module "ecs" {
  source          = "../modules/ecs"
  vpc_id          = module.vpc.vpc_id
  fargate_cpu     = var.fargate_cpu
  fargate_memory  = var.fargate_memory
  app_count       = var.app_count
  priv-sub-1-id   = module.vpc.priv-sub-1-id
  priv-sub-2-id   = module.vpc.priv-sub-2-id
  az1             = module.vpc.az1
  az2             = module.vpc.az2
  pub-sub-1-id    = module.vpc.pub-sub-1-id
  pub-sub-2-id    = module.vpc.pub-sub-2-id
  # certificate_arn = module.acm.elearning_cert_arn
}


# Create Route 53 record and domain
module "route_53" {
  source       = "../modules/route 53"
  domain_name  = var.domain_name
  alb-hostname = module.ecs.alb-hostname
  alb-zone_id  = module.ecs.alb-zone_id
}

# module "acm" {
#   source      = "../modules/acm"
#   domain_name = var.domain_name
#   aws_route53_zone_id = module.route_53.aws_route53_zone_id

# }

module "postgre_rds" {
  source           = "../modules/postgre_RDS"
  db_user          = var.db_user
  db_password      = var.db_password
  priv-sub-1-id    =  module.vpc.pub-sub-1-id
  priv-sub-2-id    =  module.vpc.priv-sub-2-id
  e-learning-sg-id =  module.ecs.e-learning-sg-id
}