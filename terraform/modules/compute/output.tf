output "webserver_pub_ips" {
  value = data.aws_instances.running_webservers.public_ips
}

output "webserver_priv_ips" {
  value = data.aws_instances.running_webservers.private_ips
}