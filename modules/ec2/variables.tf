variable "environment" {
  type        = string
  description = "The infrastructure environment"
}

variable "infra_role" {
  type        = string
  description = "Infrastructure purpose"
}

variable "instance_size" {
  type        = string
  description = "Size of the EC2 instance"
  default     = "t3.micro"
}

variable "instance_ami" {
  type        = string
  description = "Server image to use"
}

variable "instance_root_device_size" {
  type        = number
  description = "Root block device size in GB"
  default     = 8
}
