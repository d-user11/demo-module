provider "aws" {
  region  = "us-east-1"
  profile = "tfadmin"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb" {
  source     = "../../networking/alb"
  alb_name   = var.alb_name
  subnet_ids = data.aws_subnets.default.ids
}
