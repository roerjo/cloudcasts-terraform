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

resource "aws_instance" "cloudcasts_web" {
  ami           = data.aws_ami.app.id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = 8 # GB
    volume_type = "gp3"
    tags = {
      Name        = "cloudcasts-${var.environment}-web"
      Project     = "cloudcasts.io"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }

  tags = {
    Name        = "cloudcasts-${var.environment}-web"
    Project     = "cloudcasts.io"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
