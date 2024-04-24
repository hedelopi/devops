terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
	region= "us-east-1"
	access_key = "AKIA6ODUZHZ7U2UREI3Q"
	secret_key = "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"		
}

resource "tls_private_key" "rsa_4096" {
	algorithm = "RSA"
	rsa_bits  = 4096
}	

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
	key_name   = var.key_name
	public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key"{
	content = tls_private_key.rsa_4096.private_key_pem
	filename = var.key_name
}

resource "aws_instance" "public_instance" {
	ami           = "ami-080e1f13689e07408"
	instance_type = "t3.micro"
	key_name = aws_key_pair.key_pair.key_name
	
	tags = {
		Name = "Public_instance"
  }
}