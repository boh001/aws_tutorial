terraform {
  required_version = "1.7.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "backend" {
  source = "../../../modules/backend"
  backend_name = "sanghyeon-development"
}
