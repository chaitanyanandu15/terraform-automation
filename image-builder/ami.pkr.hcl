// To make Packer read these variables from the environment into the var object,
// set the environment variables to have the same name as the declared
// variables, with the prefix PKR_VAR_.

// There are other ways to [set variables](/packer/docs/templates/hcl_templates/variables#assigning-values-to-build-variables)
// including from a var file or as a command argument.

// export PKR_VAR_aws_access_key=$YOURKEY
// variable "aws_access_key" {
//   type = string
//   // default = "hardcoded_key"
// }

// // export PKR_VAR_aws_secret_key=$YOURSECRETKEY
// variable "aws_secret_key" {
//   type = string
//   // default = "hardcoded_secret_key"
// }

// data "aws_ami" "basic-example" {
//   filters = {
//     virtualization-type = "hvm"
//     name                = "al2023-ami-2023-*"
//     root-device-type    = "ebs"
//   }
//   owners      = ["137112412989"]
//   most_recent = true
// }

source "amazon-ebs" "basic-example" {
  region        = var.region
  source_ami    = var.ami_Id
  instance_type = var.instance_type
  ssh_username  = var.ssh_user_name
  ami_name      = local.ami_name_image
}

build {
  sources = [
    "source.amazon-ebs.basic-example"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo echo '<h1>Welcome to terraform class at learnwithproject</h1>' | sudo tee /var/www/html/index.html"
    ]
  }
}

