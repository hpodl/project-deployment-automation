output "webserver_ips" {
  value = [aws_instance.webserver_instance.public_ip]
}
