resource "aws_security_group" "public" {
  name        = "cloudcasts-${var.environment}-public-sg"
  description = "Public internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "cloudcasts-${var.environment}-public-sg"
    Role        = "public"
    Project     = "cloudcasts.io"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "public_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id

}

resource "aws_security_group_rule" "ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id

}

resource "aws_security_group_rule" "ingress_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id

}

resource "aws_security_group" "private" {
  name        = "cloudcasts-${var.environment}-private-sg"
  description = "Private internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "cloudcasts-${var.environment}-private-sg"
    Role        = "private"
    Project     = "cloudcasts.io"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "private_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_ingress_all" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [aws_vpc.vpc.cidr_block]

  security_group_id = aws_security_group.private.id
}
