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

resource "tls_private_key" "key_pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "webserver_ssh_key" {
  key_name   = "webserver_ssh_key"
  public_key = tls_private_key.key_pair.public_key_openssh

  # saves the private key locally with default permissions
  provisioner "local-exec" {
    command = "echo '${tls_private_key.key_pair.private_key_pem}' > '${var.private_key_path}'"
  }
}

