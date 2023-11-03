resource "aws_instance" "webserver_instance" {
  ami                         = "ami-0dbc3d7bc646e8516"
  instance_type               = "t2.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = aws_key_pair.webserver_ssh_key.key_name

  tags = {
    Name = "webserver_petclinic"
  }
}

resource "aws_autoscaling_group" "webservers_group" {
  vpc_zone_identifier = [var.subnet_id]
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3

  # target_group_arns = [aws_lb_target_group.webservers_tg.arn]
  launch_template {
    id      = aws_launch_template.webservers.id
    version = "$Latest"
  }
}


resource "aws_launch_template" "webserver_template" {
  image_id               = "ami-0dbc3d7bc646e8516"
  instance_type          = "t2.medium"
  vpc_security_group_ids = var.security_group_ids
  key_name               = aws_key_pair.webserver_ssh_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver_petclinic"
    }
  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "webserver_ssh_key" {
  key_name   = "webserver_ssh_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key_file" {
  filename        = var.private_key_path
  content         = tls_private_key.key_pair.private_key_openssh
  file_permission = "0600"
}
