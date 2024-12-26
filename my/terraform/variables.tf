variable "region" {
  type    = string
  default = "us-east-1"
}
variable "project" {
  type = map(string)
  default = {
    owner        = "SerhiiMyronets"
    project_name = "workshop"
    environment  = "dev"
  }
}
variable "instance_type" {
  type = map(string)
  default = {
    type_free = "t2.micro"
    ami_free  = "ami-0e2c8caa4b6378d8c" # ubuntu 24.04
    user      = "ubuntu"
  }
}
variable "jenkins-set" {
  type = map(string)
  default = {
    master = "jenkins-master",
    slave = "jenkins-slave"
  }
}
variable "keypair-ec2" {
  type = map(string)
  default = {
    name      = "ec2_keypair"
    algorithm = "ED25519"
    filename  = "ec2-keypair.pem"
  }
}

variable "domain_name" {
  default = "serhii.link"
}