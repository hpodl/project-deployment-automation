terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/network/vpc"
}

module "load_balancer" {
  source             = "./modules/load_balancer"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.vpc.sg_allow_http_id]
  lb_eip_id          = module.vpc.lb_eip_id
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.vpc.sg_allow_http_id, module.vpc.sg_allow_ssh_id, module.vpc.sg_egress_all_id, module.vpc.sg_all_within_subnet_id]
  private_key_path   = var.private_key_path
  target_group_arns  = [module.load_balancer.webserver_tg_arn]
}

module "bastion" {
  source             = "./modules/network/bastion"
  security_group_ids = [module.vpc.sg_allow_ssh_id]
  subnet_id          = module.vpc.subnet_id
}

module "create_ansible_files" {
  source           = "./modules/create_ansible_files"
  webserver_ips    = module.compute.webserver_priv_ips
  bastion_ip       = module.bastion.bastion_instance_ip
  private_key_path = var.private_key_path
  db_user          = var.db_user
  db_passwd        = var.db_passwd
  db_url           = module.database.db_url
}

module "database" {
  source               = "./modules/database"
  db_user              = var.db_user
  db_passwd            = var.db_passwd
  db_subnet_group_name = module.vpc.db_subnet_group_name
  db_security_groups   = [module.vpc.sg_database_id]
}
