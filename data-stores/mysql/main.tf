resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running-${var.environment}"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t4g.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password
}
