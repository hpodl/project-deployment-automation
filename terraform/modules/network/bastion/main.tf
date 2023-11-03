resource "aws_instance" "bastion_instance" {
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
