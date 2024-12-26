output "jenkins_public_ip" {
  value       = "http://${aws_instance.jenkins-set["master"].public_ip}:8080"
  description = "The public IP address of the jenkins instance"
}
output "jenkins_slave_private_ip" {
  value       = aws_instance.jenkins-set["slave"].private_ip
  description = "The private IP address of the jenkins slave instance"
}