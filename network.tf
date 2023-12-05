
resource "aws_vpc" "main" {
  # cidr_block       = "192.168.0.0/24"
  cidr_block = var.vpc_cidr_address
  # instance_tenancy = "default" 
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames_enabled
  enable_dns_support   = var.enable_dns_support_enabled

  tags = {
    #Name = "terraform-vpc"
    Name = var.vpc_name
  }
}
# data "aws_availability_zones" "this" {
#   state = "available"
# }

resource "aws_subnet" "private_subnet" {
  for_each                = { for index, az_name in slice(data.aws_availability_zones.this.names, var.start-index-private, var.end-index-private) : index => az_name }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_address, length(data.aws_availability_zones.this.names) > 3 ? 4 : 3, each.key) # Adjust subnet mask as needed
  availability_zone       = each.value
  map_public_ip_on_launch = "true"
  tags = {
    Name = "private-subnet-${each.key}"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = { for index, az_name in slice(data.aws_availability_zones.this.names, var.start-index-public, var.end-index-public) : index => az_name }
  vpc_id   = aws_vpc.main.id
  #cidr_block        = cidrsubnet(var.vpc_cidr_address, length(data.aws_availability_zones.this.names) > 3 ? 4 : 3, each.key + length(data.aws_availability_zones.this.names)) # Adjust subnet mask as needed
  cidr_block              = cidrsubnet(var.vpc_cidr_address, length(data.aws_availability_zones.this.names) > 3 ? 4 : 3, each.key + var.end-index-private) # Adjust subnet mask as needed
  availability_zone       = each.value
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# default route table, during the time of vpc default route table will be created 
resource "aws_default_route_table" "private-route" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }


  tags = {
    Name = "private-route-${aws_vpc.main.id}"
  }
}

# creating route for public transfer 
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # for public route table cidr block has to be public for internet gateway transmission of data. 
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-${aws_vpc.main.id}"
  }
}

# creating internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${aws_vpc.main.id}"
  }
}


# creating route-table association for private subnet
resource "aws_route_table_association" "private-subnet" {
  for_each       = { for index, each_subnet in aws_subnet.private_subnet : index => each_subnet.id }
  subnet_id      = each.value
  route_table_id = aws_default_route_table.private-route.id
}


resource "aws_route_table_association" "public-subnet" {
  for_each  = { for index, each_subnet in aws_subnet.public_subnet : index => each_subnet.id }
  subnet_id = each.value
  #subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route.id
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = element([for each_subnet in aws_subnet.public_subnet : each_subnet.id], 0)

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  #depends_on = [aws_internet_gateway.example]
}

# creating EIP for nat-gateway 
resource "aws_eip" "lb" {
  #instance = aws_instance.web.id
  domain = "vpc"
}



# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.main.id
#   for_each   = { for index, az_name in data.aws_availability_zones.this.names : index => az_name }
#   cidr_block = cidrsubnet(var.vpc_cidr_address, length(data.aws_availability_zones.this.names) > 4 ? 4 : 3, each.key)
#   availability_zone = each.value

#   tags = {
#     Name = "private-subnet-${each.key}"
#   }


# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id     = aws_vpc.main.id
#   for_each   = { for index, az_name in data.aws_availability_zones.this.names : index => az_name }
#   cidr_block = cidrsubnet(var.vpc_cidr_address, length(data.aws_availability_zones.this.names) > 4 ? 4 : 3, each.key + length(data.aws_availability_zones.this.names))
#   availability_zone = each.value 
#   tags = {
#     Name = "public-subnet-${each.key}"
#   }


#}



# resource "aws_subnet" "private_subnet" {
#     for_each = {for index, az_name in data.aws_availability_zones.this.names : index => az_name }
#     vpc_id = aws_vpc.main.id
#     #cidr_block = 

# }



















# resource "aws_subnet" "subnet-az1" {
#   for_each = {
#     "public-subnet-01-az1"  = "192.168.0.0/27"
#     "public-subnet-02-az1"  = "192.168.0.32/27"
#     "private-subnet-01-az1" = "192.168.0.64/27"
#   }
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = each.value
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "main-${each.key}"
#   }
# }

# resource "aws_subnet" "subnet-az2" {
#   for_each          = { "public-subnet-03-az2" : "192.168.0.96/27", "public-subnet-04-az2" : "192.168.0.128/27", "public-subnet-02-az2" : "192.168.0.160/27" }
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = each.value
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "main-${each.key}"
#   }
# }



# resource "aws_subnet" "subnet" {
#   count      = length(var.subnet1)
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.subnet1[count.index]

#   tags = {
#     Name = "subnet-${count.index + 1}"
#   }

# }




# resource "aws_subnet" "main1" {
#   for_each = {
#     "1" = "192.168.0.0/27"
#     "2" = "192.168.0.32/27"
#     "3" = "192.168.0.64/27"
#     "4" = "192.168.0.96/27"
#     "5" = "192.168.0.128/27"
#     "6" = "192.168.0.160/27"
#   }
#   vpc_id     = aws_vpc.main.id
#   cidr_block = each.value

#   tags = {
#     Name = "main-${each.key}"
#   }
# }



# resource "aws_subnet" "main1" {
#   for_each = {
#     subnet1 = "192.168.0.0/27"
#     subnet2 = "192.168.0.32/27"
#     subnet3 = "192.168.0.64/27"
#     subnet4 = "192.168.0.96/27"
#     subnet5 = "192.168.0.128/27"
#     subnet6 = "192.168.0.160/27"
#   }  
#   vpc_id     = aws_vpc.main.id
#   cidr_block = each.value

#   tags = {
#     Name = "Subnet-${each.key}"
#   }
# }

# resource "aws_subnet" "main2" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "192.168.0.32/27    "

#   tags = {
#     Name = "Main"
#   }
# }

# resource "aws_subnet" "main3" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }

# resource "aws_subnet" "main4" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }

# resource "aws_subnet" "main5" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }
# /*
# resource "aws_subnet" "main6" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }
# */

