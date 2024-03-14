locals {
  region                     = var.regions[terraform.workspace]
  cidr_block                 = var.vpc_cidr_blocks[terraform.workspace]
  public_subnets_cidr_block  = var.public_subnets_cidr_blocks[terraform.workspace]
  private_subnets_cidr_block = var.private_subnets_cidr_blocks[terraform.workspace]
}

terraform {
  required_version = "1.7.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket  = "sanghyeon-development-terraform-state"
    key     = "topology/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

provider "aws" {
  region = local.region
}

resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block
}

data "aws_availability_zones" "azs" {
  state = "available"

}

resource "aws_subnet" "public_subnets" {
  for_each          = { for idx, cidr in local.public_subnets_cidr_block : idx => cidr }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.azs.names[each.key]
}

resource "aws_subnet" "private_subnets" {
  for_each          = { for idx, cidr in local.private_subnets_cidr_block : idx => cidr }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.azs.names[each.key]
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_subnets_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "public_subnets_routes_association" {
  for_each       = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_subnets_route_table.id
  subnet_id      = each.value.id
}


resource "aws_route_table" "private_subnets_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "private_subnets_routes_association" {
  for_each       = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_subnets_route_table.id
  subnet_id      = each.value.id
}
/*
resource "aws_route_table_association" "ig_routes_association" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id     = aws_internet_gateway.ig.id
} */


/* resource "aws_nat_gateway" "nat" {
  depends_on = [ aws_internet_gateway.ig ]

  subnet_id = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat.id
  connectivity_type = "public"
} */
