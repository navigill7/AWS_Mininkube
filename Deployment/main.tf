provider "aws" {
  region = "us-east-1"
  
}

module "networking" {
  source     = "./Networking "
  cidr_block = var.cidr_block
}

module "security" {
  source = "./Security"
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source = "./Compute"
  vpc_id = module.networking.vpc_id
  security_group_id = module.security.strapi_security_group_id
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.networking.subnet1_id
  key_name = var.key_name
}