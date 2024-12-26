terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
provider "aws" {
  region = var.region
  default_tags {
    tags = { owner = var.project.owner
      project = var.project.project_name
    environment = var.project.environment }

  }
}