output "bastion_instance_ip" {
  value = aws_instance.bastion_instance.public_ip
}