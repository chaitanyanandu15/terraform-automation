resource "aws_instance" "web-bastion-host" {
  ami                    = "ami-0fa1ca9559f1892ec" #"ami-02a2af70a66af6dfb"
  key_name               = "myuckeypair"
  instance_type          = "t2.micro"
  subnet_id              = element([for each_subnet in aws_subnet.public_subnet : each_subnet.id], 0)
  vpc_security_group_ids = [aws_security_group.allow_tls_public.id]

  tags = {
    Name = "web-server-public"
  }

  #   provisioner "local-exec" {
  #     command = "scp -o StrictHostkeyChecking=no -i ~/Downloads/myuckeypair ~/Downloads/myuckeypair ec2-user@${aws_instance.web-bastion-host.public_ip}:~" 
  #   } 

  #   depends_on = [ aws_instance.web-bastion-host ]
  #   connection {
  #     type     = "ssh"
  #     user     = "root"
  #    # password = var.root_password
  #     host     = aws_instance.web-bastion-host.public_ip
  #     private_key = file("${path.module}/../../../Download/myuckeypair.pem")
  #   }

  #   provisioner "remote-exec" {
  #     inline = [
  #       "chmod 400 myuckeypair.pem"
  #     ]
  #   }
}


# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = [var.vpc_cidr_address] #ingress.value.cidr_blocks
#       // Uncomment if you need IPv6
#       // ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     // ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }




resource "aws_security_group" "allow_tls_public" {
  name        = "allow_tls_public"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  #   ingress {
  #     description = "TLS from VPC"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     #cidr_blocks = [aws_vpc.main.cidr_block]
  #     #cidr_blocks = [var.vpc_cidr_address]
  #     cidr_blocks = ["0.0.0.0/0"]
  #     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  #   }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = [aws_vpc.main.cidr_block]
    #cidr_blocks = [var.vpc_cidr_address]
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls_public"
  }
}