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