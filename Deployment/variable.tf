variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  
}

variable "ami_id" {
  description = "The AMI ID for the instance"
  type        = string
  
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  
}

