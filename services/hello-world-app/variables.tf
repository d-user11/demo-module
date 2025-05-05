variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
  default     = null
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free tier is allowed: t2.micro | t3.micro"
  }
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  validation {
    condition     = var.min_size > 0
    error_message = "ASGs can't be empty or we'll have an outage!"
  }
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  validation {
    condition     = var.max_size <= 10
    error_message = "ASGs must have 10 or fewer instances to keep costs down."
  }
}

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-084568db4383264d4"
}

variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "Hello, World"
}

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
}

variable "vpc_id" {
  description = "The VPC to deploy to"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
  default     = null
}

variable "mysql_config" {
  description = "The config for the MYSQL db"
  type = object({
    address = string
    port    = number
  })
  default = null
}
