terraform {
  required_version = "~>1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
  }
}

provider "aws" {
  # Configuration options
  #region = var.region_deploy 
  #region = "ap-south-1" 
  region = "us-east-1"
} 