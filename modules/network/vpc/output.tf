output "subnet_id" {
  value = aws_subnet.webserver_subnet.id
}

output "vpc_id" {
  value = aws_vpc.main_cloud.id
}

output "gateway_id" {
  value = aws_internet_gateway.gateway_main.id
}

output "sg_ingress_http_id" {
  value = aws_security_group.sg_ingress_http.id
}

output "sg_ingress_ssh_id" {
  value = aws_security_group.sg_ingress_ssh.id
}
