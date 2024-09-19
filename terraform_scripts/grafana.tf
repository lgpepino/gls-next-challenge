provider "aws" {
  region = "us-east-1" 
}


variable "ami_id" {
  type = string
  description = "AMI from Grafana"
}

# EC2 instance
resource "aws_instance" "grafana" {
  ami           = var.ami_id
  instance_type =  "t2.micro"

  tags = {
    Name = "Grafana-Instance"
  }
}