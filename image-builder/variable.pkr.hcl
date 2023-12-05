variable "region" {
  type        = string
  description = "giving the region"
  default     = "us-east-1"
}


variable "instance_type" {
  type        = string
  description = "providing the instance type for ami image"
  default     = "t2.micro"
}

variable "ami_name" {
  type        = string
  description = "providing the ami image for packer"
  default     = "web-server-image"
}

variable "ssh_user_name" {
  type        = string
  description = "description about ssh user name"
  default     = "ec2-user"
}

variable "ami_Id" {
  type        = string
  description = "description about ssh user name"
  default     = "ami-0230bd60aa48260c6"
}