locals {
  sql_file = "./user.sql"
}
resource "aws_db_instance" "petclinic_db" {
  allocated_storage    = 10
  db_name              = "petclinic_db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_passwd
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  provisioner "local-exec" {
    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ${local.sql_file}"
  }

}

resource "local_file" "db_create_script" {
  filename = local.sql_file
  content  = <<EOF
CREATE DATABASE IF NOT EXISTS petclinic;

ALTER DATABASE petclinic
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON petclinic.* TO '${var.db_user}'@'%' IDENTIFIED BY 'petclinic';
EOF
}
