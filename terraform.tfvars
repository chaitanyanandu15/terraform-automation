vpc_cidr_address    = "10.0.0.0/24"
vpc_name            = "terraform-deploy"
start-index-private = 0
end-index-private   = 2
start-index-public  = 0
end-index-public    = 2

ingress_rules = [
  {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #cidr_blocks = [aws_vpc.main.cidr_blocks]
  },
  {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = [var.vpc_cidr_address]
  }
]
