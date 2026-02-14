variable "aws_region" {
  default = "ap-south-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "public_key_path" {
  default = "C:/Users/sudar/.ssh/id_rsa.pub"
}

variable "ami_id" {
  default = "ami-076c6dbba59aa92e6"
}

variable "instance_type" {
  default = "t2.micro"
}
