bucket         = "my-terraform-state-bucket"
key            = "enterprise/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock"
encrypt        = true
