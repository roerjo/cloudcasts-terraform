variable "default_region" {
  type        = string
  description = "The default AWS resgion"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The infrastructure environment"
}
