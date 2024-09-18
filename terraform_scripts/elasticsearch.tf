provider "aws" {
  region = "us-east-1" 
}

variable "ami_id" {
  type = string
  description = "AMI rom ElasticSearch"
}

# Security group to allow traffic to the instance
resource "aws_security_group" "elasticsearch" {
  name        = "elasticsearch_sg"
  description = "Allow HTTP and HTTPS traffic to Elasticsearch"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "elasticsearch" {
  ami           = var.ami_id
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.elasticsearch.id]

  tags = {
    Name = "Elasticsearch-Instance"
  }
}