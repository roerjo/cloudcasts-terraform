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

  environment  = var.environment
  instance_ami = data.aws_ami.app.id
  infra_role   = "web"
}

module "ec2_worker" {
  source = "./modules/ec2"

  environment  = var.environment
  instance_ami = data.aws_ami.app.id
  infra_role   = "worker"
}
