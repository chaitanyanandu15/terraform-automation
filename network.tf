
resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

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

resource "aws_subnet" "subnet" {
  count      = length(var.subnet1)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1[count.index]

  tags = {
    Name = "subnet-${count.index + 1}"
  }

}




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

