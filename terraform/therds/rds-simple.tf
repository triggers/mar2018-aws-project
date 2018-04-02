provider "aws" {
  region = "${var.aws_region}"
}

# https://www.terraform.io/docs/providers/aws/r/db_instance.html

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true  # avoids "FinalSnapshotIdentifier is required" when destroying during dev testing
}
