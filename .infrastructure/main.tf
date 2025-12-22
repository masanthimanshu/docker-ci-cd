terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" { region = "ap-south-1" }

resource "aws_ssm_document" "deploy_app" {
  name          = "DeployApp-${var.image_tag}"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Docker image on EC2 instance"
    mainSteps = [
      {
        name   = "deploy"
        action = "aws:runShellScript"
        inputs = { runCommand = [
          "set -e",

          "docker rm -f backend || true",

          "docker pull ${var.docker_user}/testing:${var.image_tag}",
          "docker run -d --name backend -p 5500:5500 ${var.docker_user}/testing:${var.image_tag}"
        ] }
      }
    ]
  })
}

resource "aws_ssm_association" "deploy_to_ec2" {
  name = aws_ssm_document.deploy_app.name

  targets {
    key    = "tag:Role"
    values = ["BackendServer"]
  }
}
