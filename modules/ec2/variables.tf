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

variable "subnets" {
  type        = list(string)
  description = "Valid subnets to assign to a server"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups to assign to a server"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to add in"
  default     = {}
}

variable "create_public_ip" {
  type        = bool
  description = "Whether or not to create a public IP for the server"
  default     = false
}
