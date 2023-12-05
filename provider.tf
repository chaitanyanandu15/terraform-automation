terraform {
  required_version = "~>1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-file-checking"
    key            = "terraform-state-file"
    region         = "us-east-1"
    dynamodb_table = "terraform-dynamodb"
    encrypt        = true
  }
}

provider "aws" {
  # Configuration options
  #region = var.region_deploy 
  #region = "ap-south-1" 
  region = "us-east-1"
} 