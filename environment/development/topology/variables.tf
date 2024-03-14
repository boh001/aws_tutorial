variable "regions" {
  type = map(string)
  default = {
    dev = "ap-northeast-2"
    qa  = "ap-northeast-2"
  }
}

variable "vpc_cidr_blocks" {
  type = map(string)
  default = {
    dev = "10.0.0.0/16"
    qa  = "10.1.0.0/16"
  }
}

variable "public_subnets_cidr_blocks" {
  type = map(list(string))
  default = {
    dev = ["10.0.0.0/24", "10.0.1.0/24"]
    qa  = ["10.1.0.0/24", "10.1.1.0/24"]
  }
}

variable "private_subnets_cidr_blocks" {
  type = map(list(string))
  default = {
    dev = ["10.0.2.0/24", "10.0.3.0/24"]
    qa  = ["10.1.2.0/24", "10.1.3.0/24"]
  }
}
