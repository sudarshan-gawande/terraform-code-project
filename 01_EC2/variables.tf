variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI for us-east-1"
  default     = "ami-0521bc4c70257a054"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "public_key_path" {
  description = "Path to your local public key"
  default     = "C:/Users/sudar/.ssh/id_rsa.pub"
}
