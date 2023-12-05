# variable "subnet1" {
#   type    = list(string)
#   default = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27", "192.168.0.96/27", "192.168.0.128/27", "192.168.0.160/27"]

# }

variable "vpc_cidr_address" {
  type        = string
  description = "providing the vpc cidr range and address"
  default     = "10.0.0.0/24"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = "false"
}

variable "enable_dns_support_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  default     = "true"
}

variable "vpc_name" {
  type        = string
  description = "vpc_name information"
  default     = "terraform-deploy"

}

# variable "region_deploy" {
#   type        = string
#   description = "where to deploy this aws vpc and create this subnet required subnets"
#   default     = "us-east-1"

# }

variable "start-index-private" {
  type        = number
  description = "for slicing providing the start index"
  default     = 0

}

variable "end-index-private" {
  type        = number
  description = "for slicing providing the end index"
  default     = 2

}

variable "start-index-public" {
  type        = number
  description = "for slicing providing the start index"
  default     = 0

}

variable "end-index-public" {
  type        = number
  description = "for slicing providing the end index"
  default     = 1

}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    #cidr_blocks = list(string)
    // Uncomment if you need IPv6
    // ipv6_cidr_blocks = list(string)
  }))
  default = [
    {
      description = "TLS from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      # cidr_blocks = ["0.0.0.0/0"] // Replace with var.vpc_cidr_address or specific CIDR
      // ipv6_cidr_blocks = ["::/0"]
    },
    {
      description = "SSH from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      #cidr_blocks = ["0.0.0.0/0"] // Replace with var.vpc_cidr_address or specific CIDR
      // ipv6_cidr_blocks = ["::/0"]
    }
  ]
}


variable "key_name" {
  description = "keypair name"
  default     = "deployer-key"

}