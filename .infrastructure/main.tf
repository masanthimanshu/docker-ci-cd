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

          "mkdir -p /home/ec2-user/backend",

          "cat <<'EOF' > /home/ec2-user/backend/compose.yaml",
          templatefile("${path.module}/scripts/compose.yaml.tpl", {
            docker_user = var.docker_user
            image_tag   = var.image_tag
          }),
          "EOF",

          "cd /home/ec2-user/backend",
          "sudo docker-compose up -d"
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
