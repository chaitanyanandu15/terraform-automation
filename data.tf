# data "aws_availability_zones" "this" {
#   all_availability_zones = true

#   filter {
#     name   = "opt-in-status"
#     values = ["not-opted-in", "opted-in"]
#   }
# }

data "aws_availability_zones" "this" {
  state = "available"
}


data "aws_ami" "example" {
  #executable_users = ["self"]
  most_recent = true
  #name_regex       = "^myami-\\d{3}"
  owners = ["self"]

  filter {
    name   = "name"
    values = ["*-chaitanyalabs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}