terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.dev-vpc-cidr-block
  tags = {
    Name = "${var.env-prefix}-vpc"
  }
}

module "aws-subnet" {
  source                 = "./modules/subnet"
  dev-subnet-cidr-block  = var.dev-subnet-cidr-block
  env-prefix             = var.env-prefix
  availability_zone      = var.availability_zone
  vpc-id                 = aws_vpc.development-vpc.id
  default-route-table-id = aws_vpc.development-vpc.default_route_table_id
}

module "aws-webserver" {
  source            = "./modules/webserver"
  vpc-id            = aws_vpc.development-vpc.id
  env-prefix        = var.env-prefix
  instance-type     = var.instance-type
  subnet-id         = module.aws-subnet.subnet-block.id
  availability_zone = var.availability_zone
}