variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "security_group_ids" {
  type = list(string)
}
variable "name" {}
