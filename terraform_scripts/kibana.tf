provider "aws" {
  region = "us-east-1" 
}

variable "ami_id" {
  type = string
  description = "AMI do Kibana (verifique no Marketplace da AWS)"
}

# Security group to allow traffic to the instance
resource "aws_security_group" "kibana" {
  name        = "kibana_sg"
  description = "Allow HTTP traffic to Kibana"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Recurso de instância EC2
resource "aws_instance" "kibana" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.kibana.id]

  tags = {
    Name = "Kibana-Instance"
  }
}