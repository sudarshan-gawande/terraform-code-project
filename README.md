# Terraform AWS Infrastructure

Complete Terraform setup for deploying AWS infrastructure with modular design and multi-environment support.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Project Structure](#project-structure)
3. [Prerequisites](#prerequisites)
4. [Setup Guide](#setup-guide)
5. [Commands Reference](#commands-reference)
6. [State Management](#state-management)
7. [Troubleshooting](#troubleshooting)

---

## Quick Start

### 1. Initialize
```powershell
cd terraform-enterprise-aws
terraform init
```

### 2. Plan
```powershell
terraform plan -var-file="dev.tfvars"
```

### 3. Apply
```powershell
terraform apply -var-file="dev.tfvars" -auto-approve
```

### 4. Get Outputs
```powershell
terraform output
$ip = (terraform output -raw ec2_public_ip)
```

### 5. Access Instance
```powershell
ssh -i $env:USERPROFILE\.ssh\id_rsa ec2-user@$ip
```

### 6. Cleanup
```powershell
terraform destroy -var-file="dev.tfvars" -auto-approve
```

---

## Project Structure

```
terraform-enterprise-aws/
├── main.tf                    # Root module - calls other modules
├── provider.tf                # AWS provider config
├── versions.tf                # Version constraints
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── locals.tf                  # Local variables
├── backend.tf                 # State backend config
├── dev.tfvars                 # Dev environment variables
├── prod.tfvars                # Prod environment variables
├── modules/
│   ├── vpc/                   # VPC networking module
│   ├── security-group/        # Security group module
│   └── ec2/                   # EC2 instance module
└── README.md                  # This file
```

---

## Overview

The **terraform-enterprise-aws** project provides a scalable, modular infrastructure deployment for AWS with the following characteristics:

### Key Features

✅ **Modular Architecture**
- Separated VPC, Security Group, and EC2 modules
- Reusable components for different use cases
- DRY (Don't Repeat Yourself) principle

✅ **Multi-Environment Support**
- Separate configurations for `dev` and `prod` environments
- Environment-specific variable files
- State isolation via workspaces

✅ **Enterprise Grade**
- Automated tagging for cost tracking
- Default tags applied to all resources
- Remote state backend support (S3)

✅ **Version Controlled**
- Terraform version constraint (>= 1.5.0)
- AWS provider version constraint (~> 5.0)
- `.terraform.lock.hcl` for dependency locking

---

## Prerequisites

### Required Software

**Windows Installation:**

```powershell
# Terraform
choco install terraform

# AWS CLI
choco install awscli

# Git
choco install git

# SSH (built-in Windows 10/11)
ssh -V
```

**Verify Installation:**

```powershell
terraform version     # >= 1.5.0
aws --version         # v2.x.x
git --version
```

### AWS Setup

#### 1. Create IAM User

1. Go to AWS Console → IAM → Users
2. Create user: `terraform-user`
3. Enable console access
4. Attach policies:
   - `AmazonEC2FullAccess`
   - `AmazonVPCFullAccess`
   - `AmazonS3FullAccess`
   - `AmazonDynamoDBFullAccess`

#### 2. Generate Access Keys

1. Select created user → Security credentials
2. Create access key → Application running outside AWS
3. Download CSV with Access Key ID and Secret Access Key

#### 3. Configure AWS Credentials

```powershell
aws configure

# Enter:
# AWS Access Key ID: (from CSV)
# AWS Secret Access Key: (from CSV)
# Default region: us-east-1
# Default output format: json
```

**Verify:**

```powershell
aws sts get-caller-identity
```

#### 4. Generate SSH Key

```powershell
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
```

#### 5. Import SSH Key to AWS

Go to AWS Console → EC2 → Key Pairs → Import key pair

Name: `devops`  
Public key: (paste content of `$env:USERPROFILE\.ssh\id_rsa.pub`)

Or use CLI:

```powershell
aws ec2 import-key-pair --key-name devops --public-key-material file://$env:USERPROFILE\.ssh\id_rsa.pub
```

---

## Quick Start

### 30-Second Deployment (Development)

```powershell
# 1. Clone or navigate to project
cd terraform-enterprise-aws

# 2. Initialize
terraform init

# 3. Plan
terraform plan -var-file="dev.tfvars"

# 4. Deploy
terraform apply -var-file="dev.tfvars" -auto-approve

# 5. Get outputs
terraform output
```

### Access Your EC2 Instance

```powershell
# Get the public IP
$ip = (terraform output -raw ec2_public_ip)

# Connect via SSH
ssh -i $env:USERPROFILE\.ssh\id_rsa ec2-user@$ip

# Once connected, you're in your EC2 instance!
```

### Cleanup

```powershell
# Destroy all resources
terraform destroy -var-file="dev.tfvars" -auto-approve
```

---

## Setup Guide

### Step 1: Initialize Terraform

```powershell
cd terraform-enterprise-aws
terraform init
```

### Step 2: Update dev.tfvars

Default values:

```hcl
region      = "us-east-1"
environment = "dev"
vpc_cidr    = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
ami         = "ami-0c1fe732b5494dc14"    # Amazon Linux 2
instance_type = "t3.micro"
key_name    = "devops"
project_name = "terraform-enterprise-dev"
```

Modify key_name if needed to match your AWS key pair.

### Step 3: Validate Configuration

```powershell
terraform validate
terraform fmt -recursive
```

### Step 4: Plan Deployment

```powershell
terraform plan -var-file="dev.tfvars" -out="tfplan"
terraform show tfplan
```

### Step 5: Deploy Infrastructure

```powershell
terraform apply tfplan
```

### Step 6: Verify Deployment

```powershell
terraform output
$vpc_id = (terraform output -raw vpc_id)
$public_ip = (terraform output -raw ec2_public_ip)
```

### Step 7: Connect to Instance

```powershell
$ip = (terraform output -raw ec2_public_ip)
ssh -i $env:USERPROFILE\.ssh\id_rsa ec2-user@$ip
```

---

## Commands Reference

### Essential Commands

```powershell
# Initialize
terraform init

# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# Plan with variables
terraform plan -var-file="dev.tfvars"

# Save plan
terraform plan -var-file="dev.tfvars" -out="tfplan"

# Apply plan
terraform apply tfplan

# Apply without prompt
terraform apply -var-file="dev.tfvars" -auto-approve

# Show outputs
terraform output

# Get specific output
terraform output -raw ec2_public_ip

# Show state
terraform state list
terraform state show aws_instance.main

# Destroy
terraform destroy -var-file="dev.tfvars" -auto-approve
```

### Multiple Environments

```powershell
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new prod

# Switch workspace
terraform workspace select prod

# Apply to prod
terraform apply -var-file="prod.tfvars" -auto-approve

# Delete workspace
terraform workspace delete staging
```

### Debug

```powershell
# Enable debug logging
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform.log"

# Run command
terraform plan -var-file="dev.tfvars"

# View logs
Get-Content terraform.log

# Disable logging
$env:TF_LOG = ""
```

---

## State Management

### 🟢 STEP 1 — Create S3 Bucket (Terraform State Storage)

#### Go to AWS Console → S3

**1. Click "Create bucket"**

**2. Fill Details**

| Field | Value |
|-------|-------|
| Bucket name | `my-terraform-state-bucket` (must be globally unique) |
| Region | `us-west-2` (must match backend-dev.hcl region) |

**3. Block Public Access**

✅ Keep "Block all public access" = **ON**

**4. Enable Versioning** ⚠️ IMPORTANT

Scroll down → Enable:

✅ **Bucket Versioning = Enable**

This protects from accidental state corruption.

**5. Enable Encryption**

Under "Default encryption":

✅ Enable → Choose **SSE-S3** (or SSE-KMS for enterprise)

**6. Click "Create Bucket"** ✅

---

### 🟢 STEP 2 — Create DynamoDB Table (State Locking)

#### Go to AWS Console → DynamoDB

**1. Click "Create table"**

**2. Fill Details**

| Field | Value |
|-------|-------|
| Table name | `terraform-lock` |
| Partition key | `LockID` |
| Type | `String` |

⚠️ Partition key MUST be exactly: **`LockID`** (case-sensitive)

**3. Capacity Mode**

Choose: ✅ **On-demand** (Recommended)

**4. Click "Create Table"** ✅

---

### 3. Configure Backend (Optional - For Team/Production)

Once S3 bucket and DynamoDB table are created, update `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

Then reinitialize:

```powershell
terraform init -backend-config="bucket=my-terraform-state-bucket" `
               -backend-config="key=dev/terraform.tfstate" `
               -backend-config="region=us-west-2" `
               -backend-config="dynamodb_table=terraform-lock"
```

---

## Troubleshooting

### AWS Credentials Not Found

```powershell
aws configure
aws sts get-caller-identity
```

### Invalid AMI ID

```powershell
aws ec2 describe-images --owners amazon `
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-ebs" `
  --region us-east-1 `
  --query 'Images[0].ImageId' --output text
```

Update `dev.tfvars` with new AMI ID.

### Key Pair Not Found

```powershell
aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output table
aws ec2 import-key-pair --key-name devops --public-key-material file://$env:USERPROFILE\.ssh\id_rsa.pub
```

### SSH Connection Refused

1. Wait 1-2 minutes for instance to boot
2. Verify security group allows SSH (port 22)
3. Check SSH key permissions:

```powershell
icacls "$env:USERPROFILE\.ssh\id_rsa"
```

### Terraform Version Mismatch

```powershell
terraform version
choco upgrade terraform
terraform init -upgrade
```

### Invalid Resource Configuration

```powershell
terraform validate
```

---

## Best Practices

✅ **DO**:
- Use `.tfvars` files for variable values
- Commit `.gitignore` and `.terraform.lock.hcl` to Git
- Use meaningful resource names
- Tag all resources
- Use separate AWS accounts for prod
- Enable state encryption
- Keep state files private

❌ **DON'T**:
- Commit `terraform.tfstate` files to Git
- Hardcode credentials
- Use `0.0.0.0/0` CIDR in production security groups
- Commit `.env` files
- Share private SSH keys
- Use same credentials for multiple environments

---

## File Summary

| File | Purpose | Edit When |
|------|---------|-----------|
| `main.tf` | Module calls | Adding/removing modules |
| `provider.tf` | AWS auth | Changing region/tags |
| `versions.tf` | Version constraints | Upgrading |
| `variables.tf` | Variable definitions | Adding new inputs |
| `outputs.tf` | Output values | Exposing new data |
| `dev.tfvars` | Dev values | Before dev deploy |
| `prod.tfvars` | Prod values | Before prod deploy |

---

## Resources

- **Terraform Docs**: https://www.terraform.io/docs
- **AWS Documentation**: https://docs.aws.amazon.com/
- **Terraform Registry**: https://registry.terraform.io/
- **AWS Free Tier**: https://aws.amazon.com/free/

---

## Security Notes

⚠️ **Never commit to Git:**
- `terraform.tfstate*` files
- `.tfvars` files (except example)
- `.aws/credentials`
- SSH private keys (`.pem`, `id_rsa`)
- `.env` files

**Always protect:**
- State files (encrypt with S3)
- SSH keys (chmod 600)
- AWS credentials (use IAM roles)
- Restrict security groups to specific IPs in production

---

**Version**: 1.0  
**Last Updated**: February 14, 2026  
**Terraform Version**: >= 1.5.0  
**AWS Provider Version**: ~> 5.0

For detailed information, refer to official [Terraform](https://www.terraform.io/docs) and [AWS](https://docs.aws.amazon.com/) documentation.
