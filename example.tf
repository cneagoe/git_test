# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIARLKB4QXV7DPLGP2Q"
  secret_key = "VFaAD+J/XCudS1lHKIWDoEyvJ2XTRk93LJWVp3c2"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr
}