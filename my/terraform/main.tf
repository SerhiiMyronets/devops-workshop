resource "aws_instance" "ansible" {
  ami                    = var.instance_type.ami_free
  instance_type          = var.instance_type.type_free
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  key_name               = aws_key_pair.ec2-keypair.key_name
  subnet_id              = aws_subnet.project_public_subnet_01.id

  connection {
    user        = var.instance_type.user
    private_key = file(var.keypair-ec2.filename)
    host        = self.public_ip
  }
  # provisioner "file" {
  #   source      = "./ansible"
  #   destination = "./"
  # }
  #
  # provisioner "file" {
  #   source      = var.keypair-ec2.filename
  #   destination = "/home/ubuntu/.ssh/id_rsa"
  # }
  #
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 400 /home/ubuntu/.ssh/id_rsa",
  #     "sudo apt update",
  #     "sudo apt install -y software-properties-common",
  #     "sudo add-apt-repository -y --update ppa:ansible/ansible",
  #     "sudo apt install -y ansible",
  #     "ansible-playbook -i ansible/hosts ansible/jenkins-slave-setup.yaml",
  #     "ansible-playbook -i ansible/hosts ansible/jenkins-master-setup.yaml",
  #     "sudo shutdown -h now"
  #   ]
  # }
  # depends_on = [local_file.ansible-hosts]
  tags = {
    Name = "${var.project.project_name}-ansible"
  }
}

resource "aws_instance" "jenkins-set" {
  ami                    = var.instance_type.ami_free
  instance_type          = var.instance_type.type_free
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  key_name               = aws_key_pair.ec2-keypair.key_name
  subnet_id              = aws_subnet.project_public_subnet_01.id
  for_each = tomap(var.jenkins-set)
  tags = {
    Name = "${var.project.project_name}-${each.value}"
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.jenkins-set["master"].public_ip]
}

resource "aws_security_group" "project-sg" {
  vpc_id = aws_vpc.project_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Sonarqube access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project.project_name}-sg"
  }
}

module "sgs" {
  source = "./sg_eks"
  vpc_id     =     aws_vpc.project_vpc.id
}

module "eks" {
  source = "./eks"
  vpc_id     =     aws_vpc.project_vpc.id
  subnet_ids = [aws_subnet.project_public_subnet_01.id,aws_subnet.project_public_subnet_02.id]
  sg_ids = module.sgs.security_group_public
  keypair = aws_key_pair.ec2-keypair.key_name
}