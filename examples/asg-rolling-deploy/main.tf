provider "aws" {
  region  = "us-east-1"
  profile = "tfadmin"
}

variable "cluster_name" {}

module "asg" {
  source        = "../../cluster/asg-rolling-deploy"
  cluster_name  = var.cluster_name
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 1
  subnet_ids    = data.aws_subnets.default.ids
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # <--- Pay attention to fcking asterisk
  }
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
