terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.54.0"
    }
  }
  backend "s3" {
    bucket         = "cloudcasts-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "roerjo-cloudcasts"
    dynamodb_table = "cloudcasts-terraform-course"
  }
}

provider "aws" {
  region  = var.default_region
  profile = "roerjo-cloudcasts"
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Component"
    values = ["app"]
  }
  filter {
    name   = "tag:Project"
    values = ["cloudcast"]
  }
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  owners = ["self"]
}

module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_cidr    = "10.0.0.0/17"
}

module "ec2_app" {
  source = "./modules/ec2"

  environment      = var.environment
  instance_ami     = data.aws_ami.app.id
  infra_role       = "web"
  create_public_ip = true
  # For some reason a t3.micro can't be added to "US-EAST-1E"
  subnets         = ["subnet-0578825bc915e6628"] #keys(module.vpc.vpc_public_subnets)
  security_groups = [module.vpc.security_group_public]
  tags = {
    Name = "cloudcasts-${var.environment}-web"
  }
}

module "ec2_worker" {
  source = "./modules/ec2"

  environment      = var.environment
  instance_ami     = data.aws_ami.app.id
  infra_role       = "worker"
  create_public_ip = false
  subnets          = keys(module.vpc.vpc_private_subnets)
  security_groups  = [module.vpc.security_group_private]

  tags = {
    Name = "cloudcasts-${var.environment}-worker"
  }
}
