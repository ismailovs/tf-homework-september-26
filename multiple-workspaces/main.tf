terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "s_tc_1"

    workspaces {
      prefix = "customers-"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.Name
      }
}

variable "instance_type" {
   type = string
   default = "t3.micro"  
}

variable "Name" {
   type = string
   default = "Hello world"  
}