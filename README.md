# Terraform Enterprise AWS Infrastructure

A production-ready Terraform configuration for deploying a complete AWS infrastructure setup. This project demonstrates enterprise-grade infrastructure as code practices with modular design, multi-environment support, and remote state management.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Project Structure](#project-structure)
4. [Prerequisites](#prerequisites)
5. [Quick Start](#quick-start)
6. [Setup Guide](#setup-guide)
7. [Configuration](#configuration)
8. [Commands Reference](#commands-reference)
9. [Modules Documentation](#modules-documentation)
10. [Environment Management](#environment-management)
11. [State Management](#state-management)
12. [Troubleshooting](#troubleshooting)
13. [Best Practices](#best-practices)
14. [Security](#security)

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
- State isolation via workspaces or separate backends

✅ **Enterprise Grade**
- Automated tagging for cost tracking
- Default tags applied to all resources
- Organized file structure following best practices
- Remote state backend support (S3)

✅ **Version Controlled**
- Terraform version constraint (>= 1.5.0)
- AWS provider version constraint (~> 5.0)
- `.terraform.lock.hcl` for dependency locking
- GitHub Actions CI/CD support

✅ **CI/CD Ready**
- GitHub Actions workflow included
- Automated planning and validation
- Policy as code support

### What Gets Deployed

```
AWS Infrastructure Components:
├── VPC (Virtual Private Cloud)
│   ├── Public Subnet
│   ├── Internet Gateway
│   ├── Route Table
│   └── Network ACLs
├── Security Group
│   ├── Inbound Rules (SSH)
│   └── Outbound Rules (All Traffic)
└── EC2 Instance
    ├── EBS Root Volume
    ├── Security Group Attachment
    ├── Public IP/Elastic IP
    └── Key Pair Association
```

---

## Architecture

### Infrastructure Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Account                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │            VPC (vpc_cidr: 10.0.0.0/16)            │  │
│  │                                                   │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │   Public Subnet (10.0.1.0/24)               │  │  │
│  │  │   - map_public_ip_on_launch: true           │  │  │
│  │  │                                             │  │  │
│  │  │   ┌──────────────────────────────────────┐  │  │  │
│  │  │   │      EC2 Instance                    │  │  │  │
│  │  │   │  ┌─────────────────────────────────┐ │  │  │  │
│  │  │   │  │ Security Group (enterprise-sg)  │ │  │  │  │
│  │  │   │  │ - Port 22 (SSH): 0.0.0.0/0      │ │  │  │  │
│  │  │   │  │ - Outbound: All Traffic         │ │  │  │  │
│  │  │   │  └─────────────────────────────────┘ │  │  │  │
│  │  │   │                                      │  │  │  │
│  │  │   │ - Instance Type: t3.micro (dev)      │  │  │  │
│  │  │   │ - AMI: Amazon Linux 2                │  │  │  │
│  │  │   │ - Key Pair: devops (dev)             │  │  │  │
│  │  │   └──────────────────────────────────────┘  │  │  │
│  │  │                                             │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  │                   ↕                               │  │
│  │          Internet Gateway (IGW)                   │  │
│  │                   ↕                               │  │
│  │          Route Table                              │  │
│  │         (0.0.0.0/0 → IGW)                         │  │
│  │                                                   │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Terraform Modules** → Read configuration
2. **AWS Provider** → Authenticate to AWS
3. **VPC Module** → Create networking
4. **Security Group Module** → Create firewall rules
5. **EC2 Module** → Launch compute instance
6. **Terraform State** → Store infrastructure state (local or S3)

---

## Project Structure

### Complete Directory Layout

```
terraform-enterprise-aws/
├── 📄 main.tf                          # Root module - calls other modules
├── 📄 provider.tf                      # AWS provider configuration
├── 📄 versions.tf                      # Terraform and provider constraints
├── 📄 variables.tf                     # Input variables declaration
├── 📄 outputs.tf                       # Output values
├── 📄 locals.tf                        # Local variables
├── 📄 backend.tf                       # State backend configuration
│
├── 📁 modules/                         # Reusable modules
│   ├── 📁 vpc/                         # VPC module (networking)
│   │   ├── 📄 main.tf                  # VPC resources
│   │   ├── 📄 variables.tf             # VPC input variables
│   │   └── 📄 outputs.tf               # VPC outputs
│   │
│   ├── 📁 security-group/              # Security group module (firewall)
│   │   ├── 📄 main.tf                  # Security group resources
│   │   ├── 📄 variables.tf             # Input variables
│   │   └── 📄 outputs.tf               # Outputs
│   │
│   └── 📁 ec2/                         # EC2 module (compute)
│       ├── 📄 main.tf                  # EC2 instance resources
│       ├── 📄 variables.tf             # Input variables
│       └── 📄 outputs.tf               # Outputs
│
├── 📁 .github/                         # GitHub configuration
│   └── 📁 workflows/
│       └── 📄 terraform.yml            # CI/CD pipeline
│
├── 📄 dev.tfvars                       # Development environment variables
├── 📄 prod.tfvars                      # Production environment variables
├── 📄 backend-dev.hcl                  # Development backend config
├── 📄 backend-prod.hcl                 # Production backend config
│
├── 📄 dev.tfplan                       # Saved dev execution plan
├── 📄 .gitignore                       # Git ignore patterns
├── 📄 .terraform.lock.hcl              # Dependency lock file
│
├── 📁 .terraform/                      # Terraform working directory
│   ├── 📁 modules/
│   ├── 📁 providers/
│   └── 📄 terraform.tfstate            # Local state file (optional)
│
└── 📄 README.md                        # This file
```

### File Type Guide

| File | Purpose | When to Edit |
|------|---------|--------------|
| `main.tf` | Module calls and resource orchestration | When adding/removing modules |
| `provider.tf` | AWS authentication and configuration | When changing region or tags |
| `versions.tf` | Terraform and provider version constraints | When upgrading Terraform |
| `variables.tf` | Input variable definitions | When adding new variables |
| `outputs.tf` | Output values from modules | When exposing new data |
| `locals.tf` | Local computed values | When creating reusable values |
| `backend.tf` | State file location and config | When changing state storage |
| `*.tfvars` | Environment-specific values | Before each deployment |
| `.terraform.lock.hcl` | Provider version lock (auto-generated) | Never manually edit |
| `.gitignore` | Git exclusion patterns | When adding new file types to ignore |

---

## Prerequisites

### Required Software

#### 1. Terraform (>= 1.5.0)

```powershell
# Install via Chocolatey (Windows)
choco install terraform

# Or install manually
# Download from: https://www.terraform.io/downloads.html

# Verify installation
terraform version
```

Expected output:
```
Terraform v1.5.0 (or newer)
on windows_amd64
```

#### 2. AWS CLI v2

```powershell
# Install via Chocolatey (Windows)
choco install awscli

# Or install manually
# Download from: https://aws.amazon.com/cli/

# Verify installation
aws --version
```

Expected output:
```
aws-cli/2.x.x...
```

#### 3. Git (for version control)

```powershell
# Install via Chocolatey (Windows)
choco install git

# Verify installation
git --version
```

#### 4. SSH Client (for EC2 access)

Built into Windows 10/11, or use:

```powershell
# Check if SSH is available
ssh -V

# If not available, install via:
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

#### 5. Text Editor/IDE (Optional but recommended)

Choose one:
- **Visual Studio Code** (recommended): `choco install vscode`
- **Terraform Cloud IDE`: Free web-based option
- **JetBrains IntelliJ IDEA**: Full IDE with Terraform support

### System Requirements

- **OS**: Windows 10 or Windows 11
- **RAM**: Minimum 2GB, Recommended 4GB+
- **Storage**: 500MB free space
- **Internet**: Required for AWS API calls
- **Administrator Access**: For installing software (Chocolatey)

### AWS Account Setup

#### Create AWS Account

1. Go to https://aws.amazon.com/
2. Click "Create an AWS Account"
3. Follow the registration process
4. Set up billing information
5. Verify email and phone number

#### Create IAM User for Terraform

```
1. Login to AWS Management Console
2. Navigate to IAM (Identity and Access Management)
3. Click Users → Create User
4. Enter Username: terraform-user (or your preferred name)
5. Check "Provide user access to AWS Management Console"
6. Set Custom password or Auto-generated password
7. Click Next → Permissions
8. Attach Policies:
   ✓ AmazonEC2FullAccess
   ✓ AmazonVPCFullAccess
   ✓ AmazonS3FullAccess (for remote state)
   ✓ IAMFullAccess (if creating roles)
9. Click Next → Tags (optional)
10. Click Create User
```

#### Generate Access Keys

```
1. Select the IAM user you created
2. Go to Security credentials tab
3. Under "Access keys" section, click "Create access key"
4. Choose "Application running outside AWS"
5. Click Next
6. Download the .csv file with:
   - Access Key ID
   - Secret Access Key
```

⚠️ **IMPORTANT**: Save the CSV file securely. You won't be able to see the secret key again!

#### Verify IAM Permissions

```powershell
# Test AWS credentials
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDAI...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/terraform-user"
# }
```

### Configure AWS Credentials

#### Option 1: Using `aws configure` (Recommended)

```powershell
# Run AWS configuration wizard
aws configure --profile default

# When prompted, enter:
# AWS Access Key ID: AKIA... (from your CSV)
# AWS Secret Access Key: (paste from your CSV)
# Default region name: us-east-1
# Default output format: json
```

#### Option 2: Manual Configuration

Create `C:\Users\YourUsername\.aws\credentials` file:

```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[dev]
aws_access_key_id = AKIA...DEV
aws_secret_access_key = ...

[prod]
aws_access_key_id = AKIA...PROD
aws_secret_access_key = ...
```

Create `C:\Users\YourUsername\.aws\config` file:

```ini
[default]
region = us-east-1
output = json

[profile dev]
region = us-east-1

[profile prod]
region = us-east-1
```

#### Option 3: Environment Variables

```powershell
# Set temporarily in current session
$env:AWS_ACCESS_KEY_ID = "AKIA..."
$env:AWS_SECRET_ACCESS_KEY = "... "
$env:AWS_DEFAULT_REGION = "us-east-1"

# Or set permanently in System Variables
# Settings → Environment Variables → New User Variable
```

### Generate SSH Key Pair

Required for EC2 instance access:

```powershell
# Using PowerShell (Windows 10/11 with OpenSSH)
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N ""

# Or using Git Bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Verify keys created
Test-Path "$env:USERPROFILE\.ssh\id_rsa"      # Private key
Test-Path "$env:USERPROFILE\.ssh\id_rsa.pub"  # Public key

# View public key (you'll need this)
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
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

### Step 1: Clone or Download Project

```powershell
# Option A: Clone with Git
git clone <repository-url>
cd terraform-enterprise-aws

# Option B: Download manually and extract
cd d:\DevOps-Projects\Terraform\Terraform-Script\terraform-enterprise-aws
```

### Step 2: Verify Prerequisites

```powershell
# Check Terraform
terraform version     # Should show >= 1.5.0

# Check AWS CLI
aws --version         # Should show v2.x.x

# Check Git (optional)
git --version

# Check SSH
ssh -V               # Should show OpenSSH version
```

### Step 3: Configure AWS Credentials

```powershell
# Option A: Interactive configuration
aws configure

# Option B: Verify existing credentials
aws sts get-caller-identity

# It should output something like:
# {
#     "UserId": "AIDAI...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/terraform-user"
# }
```

### Step 4: Create/Import SSH Key to AWS

```powershell
# First, create SSH key pair (if you don't have one)
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N ""

# Import public key to AWS
# Navigate to AWS Console → EC2 → Key Pairs
# Click "Import key pair"
# Name: devops (or match dev.tfvars key_name)
# Public key content: (paste output of below command)
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub" | Set-Clipboard

# Paste in AWS console

# Or import via AWS CLI
aws ec2 import-key-pair --key-name devops --public-key-material "file://$env:USERPROFILE\.ssh\id_rsa.pub"
```

### Step 5: Initialize Terraform

```powershell
cd terraform-enterprise-aws

# Initialize working directory
terraform init

# Output should show:
# Initializing the backend...
# Initializing modules...
# Terraform has been successfully initialized!
```

### Step 6: Customize Variables for Your Environment

```powershell
# Edit development variables
# Open dev.tfvars in your text editor

# Current values:
# region      = "us-east-1"
# environment = "dev"
# vpc_cidr    = "10.0.0.0/16"
# public_subnet_cidr = "10.0.1.0/24"
# ami         = "ami-0c1fe732b5494dc14"
# instance_type = "t3.micro"
# key_name    = "devops"
# project_name = "terraform-enterprise-dev"

# Modify as needed for your setup
```

### Step 7: Plan Infrastructure

```powershell
# View what Terraform will create
terraform plan -var-file="dev.tfvars"

# Output should show:
# Plan: X to add, 0 to change, 0 to destroy.

# Save plan for review/auditing
terraform plan -var-file="dev.tfvars" -out="tfplan"

# View saved plan
terraform show tfplan
```

### Step 8: Deploy Infrastructure

```powershell
# Apply using interactive approval
terraform apply -var-file="dev.tfvars"
# Type 'yes' when prompted

# Or apply without prompt
terraform apply -var-file="dev.tfvars" -auto-approve

# Or apply saved plan
terraform apply tfplan
```

### Step 9: Verify Deployment

```powershell
# View outputs
terraform output

# Get specific values
$vpc_id = terraform output -raw vpc_id
$public_ip = terraform output -raw ec2_public_ip

# View AWS resources
terraform state list
terraform state show aws_instance.main

# Check AWS Console
# EC2 Dashboard → Instances → Should see "enterprise-ec2"
```

### Step 10: Access Your Instance

```powershell
# Get the public IP from Terraform output
$ip = terraform output -raw ec2_public_ip

# SSH into instance (Linux/Mac/Windows with OpenSSH)
ssh -i $env:USERPROFILE\.ssh\id_rsa ec2-user@$ip

# If using PuTTY (Windows):
# Host: ec2-user@[public-ip]
# Port: 22
# Auth: privatekey (convert id_rsa to PPK format)

# Once connected:
whoami       # Should show: ec2-user
pwd          # Should show: /home/ec2-user
ls -la       # List files

# Exit SSH
exit
```

---

## Configuration

### Environment Variables (dev.tfvars)

**File**: `dev.tfvars`

```hcl
# AWS Region - change if needed
region      = "us-east-1"

# Environment tag - used for cost tracking
environment = "dev"

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"      # VPC CIDR block
public_subnet_cidr = "10.0.1.0/24"      # Public subnet CIDR

# EC2 Instance Configuration
ami           = "ami-0c1fe732b5494dc14"  # Amazon Linux 2 AMI for us-east-1
instance_type = "t3.micro"                # Instance type (free tier eligible)
key_name      = "devops"                  # Name of AWS key pair (must exist)

# Project Information
project_name = "terraform-enterprise-dev"
```

### Configuration Details

#### Region Selection

Available AWS regions:
- `us-east-1` - N. Virginia (most services, lowest cost)
- `us-west-2` - Oregon
- `eu-west-1` - Ireland
- `ap-southeast-1` - Singapore
- `ap-south-1` - Mumbai

**Note**: Different regions have different AMI IDs for the same OS.

#### VPC and Subnet CIDR Blocks

Choose non-overlapping ranges if deploying multiple VPCs:

| Environment | VPC CIDR | Subnet CIDR | Range |
|-------------|----------|------------|-------|
| Dev | 10.0.0.0/16 | 10.0.1.0/24 | 256 IPs |
| Staging | 10.1.0.0/16 | 10.1.1.0/24 | 256 IPs |
| Prod | 10.2.0.0/16 | 10.2.1.0/24 | 256 IPs |

#### AMI Selection

Find correct AMI for your region:

```powershell
# List available Amazon Linux 2 AMIs
aws ec2 describe-images `
  --owners amazon `
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-ebs" `
  --region us-east-1 `
  --query 'Images[0].[ImageId,Name]' `
  --output text
```

#### Instance Type Selection

| Type | vCPU | RAM | Cost/Month | Use Case |
|------|------|-----|-----------|----------|
| t3.nano | 2 | 0.5GB | ~$3.80 | Development, testing |
| t3.micro | 2 | 1GB | ~$7.59 | Free tier, light workloads |
| t3.small | 2 | 2GB | ~$16.85 | Low traffic web servers |
| t2.micro | 1 | 1GB | ~$9.50 | Free tier legacy |

#### Key Pair Configuration

```powershell
# List available key pairs
aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output table

# Create new key pair (if needed)
aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > my-key.pem

# Import existing public key
aws ec2 import-key-pair --key-name devops --public-key-material file://$env:USERPROFILE\.ssh\id_rsa.pub
```

### Production Configuration (prod.tfvars)

```hcl
# Example production configuration
region      = "us-east-1"
environment = "prod"

# Production uses larger CIDR blocks and subnets
vpc_cidr           = "10.100.0.0/16"
public_subnet_cidr = "10.100.1.0/24"

# Larger, more powerful instance
ami           = "ami-0c1fe732b5494dc14"
instance_type = "t3.small"
key_name      = "prod-key"

project_name = "terraform-enterprise-prod"
```

### Updating Configuration

```powershell
# Edit variables
code dev.tfvars

# Preview changes
terraform plan -var-file="dev.tfvars" -out="tfplan"

# Review the plan carefully

# Apply if satisfied
terraform apply tfplan
```

---

## Commands Reference

### Initialization Commands

```powershell
# Initialize Terraform working directory
terraform init

# Initialize with custom backend configuration
terraform init -backend-config="backend-dev.hcl"

# Reinitialize (refresh modules and providers)
terraform init -upgrade

# Initialize and skip backend configuration
terraform init -backend=false
```

### Validation Commands

```powershell
# Validate syntax and configuration
terraform validate

# Validate with detailed output
terraform validate -json

# Format Terraform files
terraform fmt

# Format all files recursively
terraform fmt -recursive

# Check formatting without changes
terraform fmt -check
```

### Planning Commands

```powershell
# Create execution plan (shows what will happen)
terraform plan

# Plan with specific variables file
terraform plan -var-file="dev.tfvars"

# Save plan to file
terraform plan -var-file="dev.tfvars" -out="tfplan"

# Plan for destroy
terraform plan -destroy -var-file="dev.tfvars"

# Target specific resource
terraform plan -target=aws_instance.main -var-file="dev.tfvars"

# Show detailed plan
terraform plan -var-file="dev.tfvars" | Out-File plan.txt

# Get plan as JSON
terraform plan -var-file="dev.tfvars" -json
```

### Apply Commands

```powershell
# Apply with interactive approval
terraform apply -var-file="dev.tfvars"
# Type 'yes' to confirm

# Apply without asking for confirmation (use carefully!)
terraform apply -var-file="dev.tfvars" -auto-approve

# Apply saved plan (always safe, as plan is reviewed)
terraform apply tfplan

# Apply targeting specific resource
terraform apply -target=aws_instance.main -var-file="dev.tfvars" -auto-approve

# Refresh state and apply
terraform apply -refresh=true -var-file="dev.tfvars" -auto-approve
```

### State Commands

```powershell
# Show current state
terraform show

# Show specific resource state
terraform state show aws_instance.main

# List all resources in state
terraform state list

# Remove resource from state (without destroying)
terraform state rm aws_instance.main

# Pull state from backend
terraform state pull

# Push state to backend
terraform state push state.json

# Refresh state (sync with actual AWS)
terraform refresh -var-file="dev.tfvars"

# View state as JSON
terraform state pull | ConvertFrom-Json | ConvertTo-Json
```

### Output Commands

```powershell
# Display all outputs
terraform output

# Display specific output
terraform output ec2_public_ip

# Display in raw format (no JSON)
terraform output -raw ec2_public_ip

# Export outputs as JSON
terraform output -json | Out-File outputs.json

# Get into variable
$ip = (terraform output -raw ec2_public_ip)
$vpc = (terraform output -raw vpc_id)
```

### Destroy Commands

```powershell
# Destroy with confirmation prompt
terraform destroy -var-file="dev.tfvars"
# Type 'yes' to confirm

# Destroy without confirmation (use with caution!)
terraform destroy -var-file="dev.tfvars" -auto-approve

# Destroy specific resource
terraform destroy -target=aws_instance.main -var-file="dev.tfvars" -auto-approve

# Plan destroy without actually destroying
terraform plan -destroy -var-file="dev.tfvars"
```

### Workspace Commands (for multiple environments)

```powershell
# List all workspaces
terraform workspace list

# Create new workspace
terraform workspace new prod

# Select workspace
terraform workspace select prod

# Delete workspace
terraform workspace delete staging

# Show current workspace
terraform workspace show
```

### Module Commands

```powershell
# Get/download modules
terraform get

# Update modules to latest version
terraform get -update

# Show module dependencies
terraform graph | Out-File infrastructure.dot

# Get module source info
terraform get -help
```

### Debug Commands

```powershell
# Enable debug logging
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform.log"

# Run terraform command
terraform plan -var-file="dev.tfvars"

# View debug logs
Get-Content terraform.log

# Disable debug logging
$env:TF_LOG = ""
Remove-Item env:TF_LOG_PATH
```

### Advanced Commands

```powershell
# Import existing AWS resource
terraform import aws_instance.main i-1234567890abcdef0

# Taint resource (mark for recreation)
terraform taint aws_instance.main

# Untaint resource
terraform untaint aws_instance.main

# Refresh state (sync with AWS without changes)
terraform refresh

# Force unlock state lock
terraform force-unlock LOCK_ID

# Validate JSON syntax
terraform validate

# Check Terraform version
terraform version

# Get help for any command
terraform help
terraform apply -help
```

---

## Modules Documentation

### VPC Module

**Location**: `modules/vpc/`

**Purpose**: Creates VPC networking infrastructure

**Resources Created**:
- AWS VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association

**Configuration**:

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}
```

**Variables**:

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `vpc_cidr` | string | Yes | - | CIDR block for VPC |
| `public_subnet_cidr` | string | Yes | - | CIDR block for public subnet |

**Outputs**:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
  description = "VPC ID"
}

output "public_subnet_id" {
  value = aws_subnet.public.id
  description = "Public subnet ID"
}
```

**Module Code**:

```hcl
# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "enterprise-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

---

### Security Group Module

**Location**: `modules/security-group/`

**Purpose**: Creates security group with ingress/egress rules

**Resources Created**:
- AWS Security Group
- Ingress Rule (SSH)
- Egress Rule (All Traffic)

**Configuration**:

```hcl
module "security_group" {
  source = "./modules/security-group"
  
  vpc_id = module.vpc.vpc_id
}
```

**Variables**:

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `vpc_id` | string | Yes | - | VPC ID for security group |

**Outputs**:

```hcl
output "sg_id" {
  value = aws_security_group.main.id
  description = "Security group ID"
}
```

**Module Code**:

```hcl
# modules/security-group/main.tf
resource "aws_security_group" "main" {
  name   = "enterprise-sg"
  vpc_id = var.vpc_id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "enterprise-sg"
  }
}
```

**Security Note**: The SSH rule allows `0.0.0.0/0` (anywhere). For production, restrict to your IP:

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["YOUR_IP/32"]  # Your office IP
}
```

---

### EC2 Module

**Location**: `modules/ec2/`

**Purpose**: Creates EC2 instance with compute resources

**Resources Created**:
- AWS EC2 Instance
- EBS Root Volume
- Elastic IP (optional, automatic public IP in public subnet)

**Configuration**:

```hcl
module "ec2" {
  source = "./modules/ec2"
  
  ami           = "ami-0c1fe732b5494dc14"
  instance_type = "t3.micro"
  key_name      = "devops"
  subnet_id     = module.vpc.public_subnet_id
  sg_id         = module.security_group.sg_id
}
```

**Variables**:

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `ami` | string | Yes | - | AMI ID |
| `instance_type` | string | Yes | - | EC2 instance type |
| `key_name` | string | Yes | - | AWS key pair name |
| `subnet_id` | string | Yes | - | Subnet ID |
| `sg_id` | string | Yes | - | Security group ID |

**Outputs**:

```hcl
output "instance_id" {
  value = aws_instance.main.id
  description = "Instance ID"
}

output "public_ip" {
  value = aws_instance.main.public_ip
  description = "Public IP address"
}
```

**Module Code**:

```hcl
# modules/ec2/main.tf
resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "enterprise-ec2"
  }

  # Wait for instance to be fully ready
  provisioner "remote-exec" {
    inline = ["echo Connected"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}
```

---

## Environment Management

### Working with Multiple Environments

#### Development Environment

```powershell
# Initialize for development
terraform init

# Plan for dev
terraform plan -var-file="dev.tfvars" -out="dev.tfplan"

# Review plan
terraform show dev.tfplan

# Apply to dev
terraform apply dev.tfplan

# Verify
terraform output -var-file="dev.tfvars"
```

#### Production Environment

```powershell
# Plan for production
terraform plan -var-file="prod.tfvars" -out="prod.tfplan"

# Careful review of production changes
terraform show prod.tfplan | Out-File prod-plan.txt

# Apply with explicit approval
terraform apply prod.tfplan

# Save outputs for documentation
terraform output -var-file="prod.tfvars" | Out-File prod-outputs.txt
```

### Switching Between Environments

```powershell
# Check current workspace
terraform workspace show

# List available workspaces
terraform workspace list

# Create workspace for prod
terraform workspace new prod

# Switch to prod workspace
terraform workspace select prod

# Apply to prod
terraform apply -var-file="prod.tfvars" -auto-approve

# Switch back to default (dev)
terraform workspace select default
```

### Environment Differences

| Aspect | Dev | Prod |
|--------|-----|------|
| Instance Type | t3.micro | t3.small |
| VPC | 10.0.0.0/16 | 10.100.0.0/16 |
| Subnet | 10.0.1.0/24 | 10.100.1.0/24 |
| Cost/Month | ~$7.59 | ~$16.85 |
| Monitoring | Basic | CloudWatch |
| Backup | Optional | Required |

### Creating New Environment

To add a staging environment:

1. Create `staging.tfvars`:

```hcl
region      = "us-east-1"
environment = "staging"
vpc_cidr    = "10.50.0.0/16"
public_subnet_cidr = "10.50.1.0/24"
ami         = "ami-0c1fe732b5494dc14"
instance_type = "t3.micro"
key_name    = "staging-key"
project_name = "terraform-enterprise-staging"
```

2. Deploy:

```powershell
terraform plan -var-file="staging.tfvars" -out="staging.tfplan"
terraform apply staging.tfplan
```

---

## State Management

### Understanding Terraform State

**State** is how Terraform keeps track of your infrastructure. It maps your configuration to real AWS resources.

**State File**: `terraform.tfstate` (JSON format)

```json
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 123,
  "lineage": "...",
  "outputs": {
    "ec2_public_ip": {
      "value": "54.123.45.67"
    }
  },
  "resources": [
    {
      "type": "aws_instance",
      "name": "main",
      "instances": [...]
    }
  ]
}
```

### Local State (Default)

**Location**: `terraform.tfstate` in project directory

**Pros**:
- Easy to get started
- No additional setup
- Suitable for learning/dev

**Cons**:
- Not suitable for teams
- No locking mechanism
- Risk of data loss
- Credentials exposed

### Remote State with S3 Backend

**Setup S3 Backend**:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

**Commands**:

```powershell
# Initialize with S3 backend
terraform init -backend-config="backend-dev.hcl"

# Migrate state to S3
terraform init -migrate-state

# View remote state
terraform state list

# Pull remote state (create local copy)
terraform state pull > local.state

# Push to remote
terraform state push local.state
```

### State Backup and Recovery

```powershell
# Backup current state
Copy-Item terraform.tfstate "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').tfstate"

# List backups
Get-ChildItem backup-*.tfstate

# Restore from backup
Copy-Item "backup-20240214-120000.tfstate" terraform.tfstate

# Verify restoration
terraform state list
```

### State Security Best Practices

⚠️ **IMPORTANT**: State files contain sensitive information!

1. **Never commit to Git**:
```bash
# .gitignore
terraform.tfstate
terraform.tfstate.*
.terraform/
```

2. **Encrypt state at rest**:
```hcl
terraform {
  backend "s3" {
    encrypt = true  # Enable encryption
  }
}
```

3. **Restrict access**:
```bash
# File permissions
chmod 600 terraform.tfstate

# S3 bucket policy
# (Block public access, allow only specific IAM users)
```

4. **Use state locking**:
```hcl
terraform {
  backend "s3" {
    dynamodb_table = "terraform-locks"  # Prevents concurrent operations
  }
}
```

### State Locking

Prevents concurrent modifications:

```powershell
# View locks
terraform state list

# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Lock timeout
# (Terraform automatically times out locks after 15 minutes)
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. AWS Credentials Not Found

**Error**:
```
Error: error configuring Terraform AWS Provider: no valid credential sources found
```

**Solution**:

```powershell
# Check if credentials file exists
Test-Path "$env:USERPROFILE\.aws\credentials"

# Configure AWS CLI
aws configure

# Or set environment variables
$env:AWS_ACCESS_KEY_ID = "YOUR_KEY"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_SECRET"

# Verify credentials
aws sts get-caller-identity
```

#### 2. Invalid AMI ID for Region

**Error**:
```
Error: InvalidAMIID.NotFound: 'ami-0c1fe732b5494dc14' does not exist
```

**Solution**:

```powershell
# Find correct AMI for your region
aws ec2 describe-images `
  --owners amazon `
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-ebs" `
  --query 'Images[0].ImageId' `
  --output text

# Update dev.tfvars with new AMI ID
```

#### 3. Key Pair Not Found

**Error**:
```
Error: InvalidKeyPair.NotFound: The key pair 'devops' does not exist
```

**Solution**:

```powershell
# List available key pairs
aws ec2 describe-key-pairs --query 'KeyPairs[].KeyName' --output table

# Import your public key
aws ec2 import-key-pair `
  --key-name devops `
  --public-key-material file://$env:USERPROFILE\.ssh\id_rsa.pub

# Update dev.tfvars to match key name
```

#### 4. Insufficient Permissions

**Error**:
```
Error: User: arn:aws:iam::123456789012:user/username is not authorized
```

**Solution**:

1. Check current user:
```powershell
aws sts get-caller-identity
```

2. Verify IAM permissions:
   - Go to AWS Console → IAM → Users
   - Click your username
   - Check Permissions tab
   - Should have: EC2, VPC, S3 FullAccess

3. Add missing policies:
```bash
# In AWS Console:
# Attach Policies:
# - AmazonEC2FullAccess
# - AmazonVPCFullAccess
# - AmazonS3FullAccess
```

#### 5. State Lock Timeout

**Error**:
```
Error: Error acquiring the state lock: ConditionalCheckFailedException
```

**Solution**:

```powershell
# Check for locks
terraform state list

# Wait 15 minutes (auto-timeout)

# Or force unlock (dangerous!)
terraform force-unlock LOCK_ID
```

#### 6. SSH Connection Refused

**Error**:
```
ssh: connect to host 54.123.45.67 port 22: Connection refused
```

**Solution**:

```powershell
# Wait 1-2 minutes for instance to fully boot
Start-Sleep -Seconds 120

# Verify security group allows SSH
aws ec2 describe-security-groups --query 'SecurityGroups[0].IpPermissions'

# Try SSH with verbose output
ssh -vvv -i $env:USERPROFILE\.ssh\id_rsa ec2-user@IP

# Verify SSH key permissions
icacls "$env:USERPROFILE\.ssh\id_rsa"
```

#### 7. Terraform Version Mismatch

**Error**:
```
Error: Unsupported Terraform Version
```

**Solution**:

```powershell
# Check current version
terraform version

# Upgrade Terraform
choco upgrade terraform

# Or install specific version
choco install terraform --version=1.5.0

# Reinitialize
terraform init -upgrade
```

#### 8. Module Not Found

**Error**:
```
Error: Failed to read module directory
```

**Solution**:

```powershell
# Check module paths
Get-ChildItem modules -Recurse -Include main.tf

# Verify module source paths in main.tf
# Should be: source = "./modules/vpc"

# Reinitialize modules
terraform get -update
terraform init -upgrade
```

#### 9. Invalid Resource Configuration

**Error**:
```
Error: Missing required argument
```

**Solution**:

```powershell
# Validate configuration
terraform validate

# Check for typos
Get-Content variables.tf

# Review module calls in main.tf
# Ensure all required variables are provided
```

#### 10. Out of Capacity

**Error**:
```
Error: InsufficientInstanceCapacity: We currently do not have sufficient capacity
```

**Solution**:

```powershell
# Change instance type or region
# Edit dev.tfvars

# Option 1: Try different instance type
instance_type = "t2.micro"

# Option 2: Try different region
region = "us-west-2"

# Option 3: Wait and retry
Start-Sleep -Seconds 300
terraform apply -var-file="dev.tfvars" -auto-approve
```

### Debug Logging

```powershell
# Enable detailed logging
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform.log"

# Run any terraform command
terraform plan -var-file="dev.tfvars"

# Review logs
Get-Content terraform.log | Select-String "error" -Context 3

# Disable logging
$env:TF_LOG = ""
Remove-Item terraform.log
```

### Getting Help

1. **Official Documentation**: https://www.terraform.io/docs
2. **AWS Documentation**: https://docs.aws.amazon.com/
3. **Terraform Registry**: https://registry.terraform.io/
4. **Stack Overflow**: Use tag `terraform`
5. **GitHub Issues**: https://github.com/hashicorp/terraform/issues

---

## Best Practices

### 1. Variable Management

**DO**:
```hcl
# Use descriptive variable names
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

# Provide help text
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

# Use validation
variable "instance_type" {
  type = string
  
  validation {
    condition     = can(regex("^t[2-3]", var.instance_type))
    error_message = "Must be t2 or t3 instance family"
  }
}
```

**DON'T**:
```hcl
# Don't use unclear names
variable "it" {
  type = string
}

# Don't omit defaults
variable "region" {
  type = string
}

# Don't accept all values
variable "type" {
  type = string
}
```

### 2. Resource Tagging

Always tag resources for cost tracking:

```hcl
provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "DevOps"
      CostCenter  = "IT"
      CreatedDate = timestamp()
    }
  }
}
```

### 3. Module Organization

```
modules/
├── vpc/
│   ├── main.tf           # Resources
│   ├── variables.tf      # Inputs with descriptions
│   ├── outputs.tf        # Outputs with descriptions
│   └── README.md         # Module documentation
├── security-group/
└── ec2/
```

### 4. Version Management

```hcl
# Always specify versions
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### 5. Code Formatting

```powershell
# Format before committing
terraform fmt -recursive

# Check formatting
terraform fmt -check -recursive

# Use consistent indentation (2 spaces)
```

### 6. State Security

```bash
# .gitignore
terraform.tfstate
terraform.tfstate.*
.terraform/
crash.log
*.tfplan
```

### 7. Pre-Deployment Checklist

```powershell
# ✓ Validate syntax
terraform validate

# ✓ Format code
terraform fmt -recursive

# ✓ Plan and save
terraform plan -var-file="dev.tfvars" -out="tfplan"

# ✓ Review plan
terraform show tfplan | Out-File plan-review.txt

# ✓ Check for hardcoded secrets
grep -r "password\|secret\|token" . | grep -v ".git"

# ✓ Verify variables
# Review dev.tfvars for correctness

# ✓ Apply
terraform apply tfplan
```

### 8. Documentation

```markdown
# VPC Module

## Overview
Creates a VPC with public subnet configured for high availability.

## Usage
```hcl
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}
```

## Variables
| Name | Type | Required |
|------|------|----------|
| vpc_cidr | string | Yes |
| public_subnet_cidr | string | Yes |

## Outputs
| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| subnet_id | Subnet ID |
```

### 9. Backup and Recovery

```powershell
# Backup state before major changes
Copy-Item terraform.tfstate "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').tfstate"

# Backup outputs
terraform output | Out-File outputs-backup.json

# Test recovery procedures
# (in non-prod environment)
```

### 10. Cost Optimization

```hcl
# Use free-tier eligible resources
variable "instance_type" {
  type    = string
  default = "t2.micro"  # Free tier
}

# Use spot instances for non-critical workloads
resource "aws_instance" "batch" {
  instance_market_options {
    market_type = "spot"
  }
}

# Set appropriate retention periods
resource "aws_cloudwatch_log_group" "example" {
  retention_in_days = 7  # Reduce storage costs
}

# Tag for cost allocation
tags = {
  CostCenter = "IT"
  Billable   = "true"
}
```

---

## Security

### 1. Credentials Management

**DO**:
```powershell
# Use AWS CLI configured credentials
aws configure

# Use environment variables (temporary)
$env:AWS_ACCESS_KEY_ID = "..."
$env:AWS_SECRET_ACCESS_KEY = "..."

# Use IAM roles (for EC2)
```

**DON'T**:
```hcl
# ❌ Never hardcode credentials
provider "aws" {
  access_key = "AKIA..."
  secret_key = "..."
}

# ❌ Never commit .aws/credentials to Git
```

### 2. Security Group Rules

**DO** (Production):
```hcl
# Restrict to specific IPs
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["203.0.113.0/24"]  # Your office IP
}
```

**DON'T** (Development only):
```hcl
# ❌ Open to world (dev only)
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

### 3. SSH Key Security

```powershell
# Protect private key
icacls "$env:USERPROFILE\.ssh\id_rsa" /inheritance:r /grant:r "%USERNAME%:F"

# Never share private key
# Never commit private key to Git

# Rotate keys regularly
# Create new key pair and import to AWS
```

### 4. State File Encryption

```hcl
terraform {
  backend "s3" {
    bucket         = "my-state-bucket"
    encrypt        = true      # Enable encryption
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

### 5. IAM Principle of Least Privilege

Instead of full access:

```hcl
# Only grant needed permissions
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:DescribeInstances",
        "vpc:CreateSecurityGroup",
        "vpc:DeleteSecurityGroup"
      ],
      "Resource": "*"
    }
  ]
}
```

### 6. Audit and Logging

```powershell
# Enable CloudTrail for API auditing
# Enable VPC Flow Logs for network monitoring
# Enable CloudWatch for instance monitoring

# Review Terraform logs
$env:TF_LOG = "DEBUG"
```

### 7. Secrets Management

For sensitive data (DB passwords, API keys):

```powershell
# Option 1: AWS Secrets Manager
data "aws_secretsmanager_secret_version" "password" {
  secret_id = "prod/db/password"
}

# Option 2: AWS Systems Manager Parameter Store
data "aws_ssm_parameter" "api_key" {
  name = "/prod/api/key"
}

# Option 3: HashiCorp Vault
```

### 8. Network Security

```hcl
# Use VPC for isolation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Use private subnets for sensitive resources
resource "aws_subnet" "private" {
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
}

# Use NAT Gateway for private outbound traffic
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}
```

### 9. Regular Updates

```powershell
# Update Terraform
choco upgrade terraform

# Update AWS provider
terraform init -upgrade

# Review security advisories
# - Terraform Security Advisories: https://www.terraform.io/security
# - AWS Security Advisories: https://aws.amazon.com/security/
```

### 10. Access Control

```bash
# Restrict .aws/credentials permissions
chmod 600 ~/.aws/credentials

# Use separate credentials for dev/prod
# Use different AWS accounts for different environments

# Enable MFA for root account
# Enable MFA for privileged users
```

---

## Additional Resources

### Documentation
- **Terraform Docs**: https://www.terraform.io/docs
- **AWS Docs**: https://docs.aws.amazon.com/
- **Terraform Registry**: https://registry.terraform.io/

### Learning
- **Terraform Learning**: https://learn.hashicorp.com/terraform
- **AWS Learning**: https://aws.amazon.com/training/
- **Free Tier**: https://aws.amazon.com/free/

### Tools
- **Terraform Cloud**: https://app.terraform.io/
- **Terraform Enterprise**: https://www.hashicorp.com/products/terraform/enterprise
- **AWS CloudFormation**: https://aws.amazon.com/cloudformation/

### Community
- **Terraform Discuss**: https://discuss.hashicorp.com/
- **Stack Overflow**: Tag `terraform`
- **GitHub Discussions**: https://github.com/hashicorp/terraform/discussions

---

## Changelog

### Version 1.0.0 (Current)
- ✅ VPC module with public subnet
- ✅ Security group module with SSH access
- ✅ EC2 module with instance configuration
- ✅ Dev and prod environment support
- ✅ State backend configuration
- ✅ GitHub Actions CI/CD workflow
- ✅ Comprehensive documentation

---

## Support

For issues or questions:

1. **Check Troubleshooting** section above
2. **Run validation**: `terraform validate`
3. **Enable debug logging**: `$env:TF_LOG = "DEBUG"`
4. **Check AWS Console** for actual resource status
5. **Review CloudTrail logs** for API errors

---

## License

This Terraform configuration is provided as-is for educational and development purposes.

---

## Summary

### Files Overview

| File | Purpose | Edit When |
|------|---------|-----------|
| `main.tf` | Module orchestration | Adding/removing modules |
| `provider.tf` | AWS authentication | Changing region/tags |
| `versions.tf` | Version constraints | Upgrading Terraform |
| `variables.tf` | Variable definitions | Adding new inputs |
| `outputs.tf` | Output values | Exposing new data |
| `locals.tf` | Local values | Computing reusable values |
| `backend.tf` | State backend | Changing state storage |
| `dev.tfvars` | Dev configuration | Before dev deployment |
| `prod.tfvars` | Prod configuration | Before prod deployment |

### Quick Commands

```powershell
terraform init                              # Initialize
terraform validate                          # Check syntax
terraform plan -var-file="dev.tfvars"      # Preview changes
terraform apply -var-file="dev.tfvars"     # Deploy
terraform output                            # View outputs
terraform destroy -var-file="dev.tfvars"   # Cleanup
```

### Deployment Flow

```
1. terraform init              (Initialize)
2. terraform validate          (Validate)
3. terraform plan -out=tfplan  (Plan)
4. terraform show tfplan       (Review)
5. terraform apply tfplan      (Deploy)
6. terraform output            (Verify)
```

---

**Last Updated**: February 14, 2026
**Terraform Version Required**: >= 1.5.0
**AWS Provider Version Required**: ~> 5.0

For the latest updates and information, refer to the official Terraform and AWS documentation.
