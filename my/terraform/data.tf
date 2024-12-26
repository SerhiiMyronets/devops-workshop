resource "random_pet" "random" {}
data "aws_availability_zones" "project_az" {}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}