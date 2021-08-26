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

  tags = {
    Name        = "cloudcasts-${var.environment}-web"
    Project     = "cloudcasts.io"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
