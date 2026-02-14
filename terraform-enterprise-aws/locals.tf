locals {
  common_tags = {
    Project     = "terraform-enterprise"
    Environment = var.environment
    Owner       = "DevOps-Team"
  }
}
