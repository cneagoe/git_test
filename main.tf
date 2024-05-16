terraform {
  backend "remote" {
    organization = "itschool"

    workspaces {
      name = "git-test"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = "AKIARLKB4QXV5PTG7GGN"
  secret_key = "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"
}
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet1_cidr  = "10.0.1.0/24"
  public_subnet2_cidr  = "10.0.2.0/24"
  private_subnet1_cidr = "10.0.3.0/24"
  private_subnet2_cidr = "10.0.4.0/24"
  availability_zone1   = "eu-west-3a"
  availability_zone2   = "eu-west-3b"
}

module "alb" {
  source         = "./modules/alb"
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

module "ec2" {
  source           = "./modules/ec2"
  public_subnets   = module.vpc.public_subnets
  ami_id           = data.aws_ami.amazon_linux.id
  instance_type    = "t2.micro"
  key_name         = "jmac-le-pair"
  webserver_sg_id  = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn
}

module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  db_name         = "luitweek22db"
  db_username     = "dbusername"
  db_password     = "dbpassword"
  sg_id           = module.alb.alb_sg_id
}