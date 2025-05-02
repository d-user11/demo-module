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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # <--- Pay attention to fcking asterisk
  }
}

module "hello-world-app" {
  source = "../../services/hello-world-app"

  environment = "test"
  server_text = "Hello World App"

  vpc_id      = data.aws_vpc.default.id
  subnet_ids  = data.aws_subnets.default.ids
  server_port = 8080

  instance_type = "m4.large"
  ami           = data.aws_ami.ubuntu.id

  min_size = 3
  max_size = 3
}
