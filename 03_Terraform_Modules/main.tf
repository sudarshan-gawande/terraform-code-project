provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "terraform-module-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ec2_sg" {
  name        = "module_sg"
  description = "Allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "ec2_1" {
  source             = "./modules/ec2_instance"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.deployer_key.key_name
  security_group_ids = [aws_security_group.ec2_sg.id]
  name               = "ec2-from-module-1"
}

module "s3_1" {
  source      = "./modules/s3_bucket"
  bucket_name = "my-terraform-bucket-01-${random_id.suffix.hex}"
  environment = "dev"
}


