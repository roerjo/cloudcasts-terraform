output "app_ip" {
  value = aws_instance.cloudcasts_web.public_ip
}

output "app_instance" {
  value = aws_instance.cloudcasts_web.id
}
