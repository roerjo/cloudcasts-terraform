resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}

resource "aws_instance" "cloudcasts_web" {
  ami           = var.instance_ami
  instance_type = var.instance_size

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = var.instance_root_device_size # GB
    volume_type = "gp3"
    tags = {
      Name        = "cloudcasts-${var.environment}-web"
      Project     = "cloudcasts.io"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }

  subnet_id                   = random_shuffle.subnets.result[0]
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = var.create_public_ip ? true : false

  tags = merge(
    {
      Name        = "cloudcasts-${var.environment}"
      Project     = "cloudcasts.io"
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}
