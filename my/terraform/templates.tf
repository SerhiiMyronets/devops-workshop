resource "tls_private_key" "ec2-keypair" {
  algorithm = var.keypair-ec2.algorithm
}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.ec2-keypair.private_key_openssh
  filename = var.keypair-ec2.filename

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key_pem.filename}"
  }
}
resource "aws_key_pair" "ec2-keypair" {
  key_name   = "${var.keypair-ec2.name}-${random_pet.random.id}"
  public_key = tls_private_key.ec2-keypair.public_key_openssh
}


resource "local_file" "ansible-hosts" {
  filename = "./ansible/hosts"
  content = templatefile("./templates/ansible-hosts.tftpl", {
    master-name = var.jenkins-set.master
    master-ip   = aws_instance.jenkins-set["master"].private_ip
    slave-name  = var.jenkins-set.slave
    slave-ip    = aws_instance.jenkins-set["slave"].private_ip
    user-name   = var.instance_type.user
  })
}