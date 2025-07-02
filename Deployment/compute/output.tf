variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
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
variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched"
  type        = string
  
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the instance"
  type        = string
  
}


variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  
}


