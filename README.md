# Terraform AWS Infrastructure Scripts

A comprehensive collection of Terraform configurations for deploying and managing AWS infrastructure. This project includes multiple examples ranging from simple EC2 instances to complex modularized enterprise-grade deployments.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Project Structure](#project-structure)
3. [Prerequisites](#prerequisites)
4. [AWS Account Setup](#aws-account-setup)
5. [General Terraform Workflow](#general-terraform-workflow)
6. [Projects Guide](#projects-guide)
   - [01_EC2 - Basic EC2 with Dev/Prod Environments](#01ec2---basic-ec2-with-devprod-environments)
   - [02_multi_ec2 - Multiple EC2 Instances](#02multi_ec2---multiple-ec2-instances)
   - [03_Terraform_Modules - Modular EC2 and S3](#03terraform_modules---modular-ec2-and-s3)
   - [04_ec2 - Single EC2 Instance](#04ec2---single-ec2-instance)
   - [05_DemoEC2 - Demo EC2 Setup](#05demoec2---demo-ec2-setup)
   - [06-Module - Multi-Module EC2 and S3](#06-module---multi-module-ec2-and-s3)
   - [terraform-enterprise-aws - Enterprise VPC Setup](#terraform-enterprise-aws---enterprise-vpc-setup)
7. [Commands Reference](#commands-reference)
8. [State Management](#state-management)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)

---

## Project Overview

This Terraform project collection demonstrates various AWS infrastructure deployment patterns:

- **Basic EC2 Deployment**: Simple single Instance deployments
- **Multi-Instance Management**: Using count meta-arguments to manage multiple resources
- **Modular Architecture**: Reusable Terraform modules for scalable infrastructure
- **Multi-Environment Setup**: Dev and Production environment management
- **Enterprise Architecture**: Complete VPC setup with security groups and EC2 instances

### Technologies Used

- **Terraform**: Infrastructure as Code tool (version >= 1.5.0)
- **AWS Provider**: Terraform AWS provider (version ~> 5.0)
- **AWS Services**: EC2, VPC, S3, Security Groups, Key Pairs

---

## Project Structure

```
Terraform-Script/
├── 01_EC2/                          # Basic EC2 with multi-environment support
│   ├── main.tf                      # EC2, Security Group, Key Pair configuration
│   ├── variables.tf                 # Input variables
│   ├── output.tf                    # Output values
│   ├── dev.tfvars                   # Development environment variables
│   ├── prod.tfvars                  # Production environment variables
│   └── terraform.tfstate.d/         # State storage for different workspaces
│       ├── dev/
│       └── prod/
│
├── 02_multi_ec2/                    # Multiple EC2 instances using count
│   ├── main.tf                      # Multiple EC2 instances configuration
│   ├── variables.tf                 # Input variables
│   ├── outputs.tf                   # Output values
│   ├── terraform.tfvars             # Default variables
│   ├── terraform.tfstate            # Current state
│   └── terraform.tfstate.backup     # State backup
│
├── 03_Terraform_Modules/            # Reusable modules for EC2 and S3
│   ├── main.tf                      # Module calls
│   ├── variables.tf                 # Input variables
│   ├── output.tf                    # Output values
│   ├── terraform.tfvars             # Default variables
│   ├── modules/
│   │   ├── ec2_instance/            # EC2 reusable module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── s3_bucket/               # S3 reusable module
│   │       ├── main.tf
│   │       ├── variable.tf
│   │       └── output.tf
│   └── terraform.tfstate*          # State files
│
├── 04_ec2/                          # Simple EC2 instance
│   ├── main.tf                      # EC2 configuration
│   ├── input-var.tf                 # Input variables
│   ├── out-var.tf                   # Output variables
│   └── terraform.tfstate*           # State files
│
├── 05_DemoEC2/                      # Demo EC2 setup
│   ├── main.tf                      # EC2 configuration
│   ├── input-vars.tf                # Input variables
│   ├── output-vars.tf               # Output variables
│   └── terraform.tfstate*           # State files
│
├── 06-Module/                       # Modularized infrastructure
│   ├── main.tf                      # Module calls
│   ├── provider.tf                  # AWS Provider configuration
│   ├── variable.tf                  # Input variables
│   ├── output.tf                    # Output values
│   ├── dev.tfvars                   # Development variables
│   ├── prod.tfvars                  # Production variables
│   ├── EC2/                         # EC2 module
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── output.tf
│   ├── S3/                          # S3 module
│   │   └── *
│   └── terraform.tfstate.d/         # Workspace states
│       ├── dev/
│       └── prod/
│
├── terraform-enterprise-aws/        # Enterprise-grade complete setup
│   ├── main.tf                      # Main configuration calling modules
│   ├── provider.tf                  # AWS Provider configuration
│   ├── versions.tf                  # Terraform and provider versions
│   ├── variables.tf                 # Input variables
│   ├── outputs.tf                   # Output values
│   ├── locals.tf                    # Local variables
│   ├── backend.tf                   # Backend configuration
│   ├── dev.tfvars                   # Development variables
│   ├── prod.tfvars                  # Production variables
│   ├── backend-dev.hcl              # Development backend configuration
│   ├── backend-prod.hcl             # Production backend configuration
│   ├── dev.tfplan                   # Saved Terraform plan for dev
│   ├── modules/
│   │   ├── vpc/                     # VPC module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── security-group/          # Security Group module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── ec2/                     # EC2 module
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   └── terraform.tfstate*           # State files
│
└── README.md                        # This file
```

### File Type Descriptions

- **main.tf**: Primary configuration file containing resource definitions
- **variables.tf / input*.tf**: Input variable definitions for customization
- **outputs.tf / output*.tf**: Output values returned after resource creation
- **provider.tf**: AWS provider and authentication configuration
- **versions.tf**: Terraform and provider version requirements
- **backend.tf**: Remote state backend configuration
- **locals.tf**: Local variable definitions
- ***.tfvars**: Variable value files for different environments
- **terraform.tfstate**: Current state file (not recommended for version control)
- **terraform.tfstate.backup**: Automatic state backup

---

## Prerequisites

### Required Software

1. **Terraform** (>= 1.5.0)
   ```bash
   # Windows with Chocolatey
   choco install terraform
   
   # Windows with Scoop
   scoop install terraform
   
   # Or download from https://www.terraform.io/downloads.html
   ```

2. **AWS CLI** (v2)
   ```bash
   # Windows - Download from https://aws.amazon.com/cli/
   # Or use Chocolatey
   choco install awscli
   ```

3. **Git** (for version control)
   ```bash
   choco install git
   ```

### Verify Installation

```bash
terraform --version
aws --version
git --version
```

### System Requirements

- Windows 10/11 with PowerShell or Command Prompt
- Internet connection for AWS API calls
- Sufficient AWS account limits for resources
- Approximately 2GB free disk space

---

## AWS Account Setup

### 1. Create AWS Account

If you don't have an AWS account, create one at https://aws.amazon.com/

### 2. Create IAM User with Programmatic Access

```bash
# Steps:
# 1. Go to AWS Management Console
# 2. Navigate to IAM > Users > Create user
# 3. Enable "Provide user access to the AWS Management Console"
# 4. Set custom password or auto-generated
# 5. Skip permission groups (we'll add policies)
# 6. Go to Users > Select created user
# 7. Click "Security credentials" tab
# 8. Create access key > Application running outside AWS
# 9. Download CSV with Access Key ID and Secret Access Key
```

### 3. Attach Required IAM Policies

Attach these managed policies to your IAM user:
- `AmazonEC2FullAccess`
- `AmazonS3FullAccess`
- `AmazonVPCFullAccess`
- `IAMFullAccess` (for creating roles if needed)

### 4. Configure AWS Credentials

#### Option A: Using AWS CLI (Recommended)

```powershell
aws configure
```

Enter when prompted:
- AWS Access Key ID: `Your Access Key ID`
- AWS Secret Access Key: `Your Secret Access Key`
- Default region: `us-east-1` (or your preferred region)
- Default output format: `json`

#### Option B: Manual Configuration

Create or edit `C:\Users\YourUsername\.aws\credentials`:

```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY

[dev-profile]
aws_access_key_id = DEV_ACCESS_KEY_ID
aws_secret_access_key = DEV_SECRET_ACCESS_KEY

[prod-profile]
aws_access_key_id = PROD_ACCESS_KEY_ID
aws_secret_access_key = PROD_SECRET_ACCESS_KEY
```

Create or edit `C:\Users\YourUsername\.aws\config`:

```ini
[default]
region = us-east-1
output = json

[profile dev-profile]
region = us-east-1

[profile prod-profile]
region = ap-south-1
```

### 5. Verify AWS Credentials

```powershell
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDAI...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/username"
# }
```

### 6. Generate SSH Key Pair (Required for EC2)

```powershell
# If using Windows 10/11 with OpenSSH
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa -N ""

# Or use Git Bash if installed
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Verify public key was created
Test-Path "$env:USERPROFILE\.ssh\id_rsa.pub"
```

---

## General Terraform Workflow

### Standard Terraform Commands Flow

```
Initialize → Validate → Plan → Apply → Verify → Destroy (when done)
```

### Detailed Workflow

#### 1. Initialize Terraform Working Directory

```bash
cd path/to/project
terraform init
```

**What it does:**
- Downloads required provider plugins (AWS)
- Creates `.terraform/` directory
- Initializes backend if configured
- Creates lock file (`.terraform.lock.hcl`)

#### 2. Validate Configuration

```bash
terraform validate
```

**What it does:**
- Checks syntax correctness
- Validates configuration structure
- Returns errors if configuration is invalid

#### 3. Plan Infrastructure Changes

```bash
# View changes without applying
terraform plan

# Save plan to file for later review/apply
terraform plan -out=tfplan

# Target specific resources
terraform plan -target=aws_instance.example

# Show sensitive values
terraform plan -json
```

**What it does:**
- Shows what Terraform will do
- Compares desired state (code) with current state
- Does not make any changes
- Returns detailed execution plan

#### 4. Apply Infrastructure Changes

```bash
# Apply with interactive approval
terraform apply

# Apply without confirmation (use with caution)
terraform apply -auto-approve

# Apply previous plan
terraform apply tfplan

# Target specific resources
terraform apply -target=aws_instance.example
```

**What it does:**
- Creates/modifies/destroys resources
- Updates state file
- Prints outputs
- Is reversible with destroy

#### 5. View Current State

```bash
# Show all resources in state
terraform show

# Show resource attributes
terraform state show aws_instance.example

# List all resources
terraform state list
```

#### 6. Destroy Infrastructure

```bash
# Remove all resources
terraform destroy

# Remove without confirmation
terraform destroy -auto-approve

# Remove specific resources
terraform destroy -target=aws_instance.example
```

---

## Projects Guide

### 01_EC2 - Basic EC2 with Dev/Prod Environments

**Purpose**: Demonstrates single EC2 instance deployment with separate dev and prod environments using Terraform workspaces.

**What it deploys:**
- Single EC2 instance
- Security group allowing SSH (port 22)
- AWS key pair for SSH access

**Key features:**
- Separate variable files for dev and prod
- Uses Terraform workspaces for state separation
- Simple, easy-to-understand configuration

#### Configuration

**Edit variables:**

```bash
# For development
cd 01_EC2
# Edit dev.tfvars
```

Update `dev.tfvars`:
```hcl
# AWS settings
# aws_region defaults to "ap-south-1" from variables.tf
# ami_id defaults to "ami-0521bc4c70257a054" (Amazon Linux 2)
# instance_type defaults to "t2.nano"

# SSH key path - UPDATE THIS
# public_key_path = "C:/Users/sudar/.ssh/id_rsa.pub"
```

#### Commands

```powershell
cd 01_EC2

# Initialize
terraform init

# Create development workspace
terraform workspace new dev
terraform workspace select dev

# Plan with dev variables
terraform plan -var-file="dev.tfvars"

# Apply to dev
terraform apply -var-file="dev.tfvars" -auto-approve

# View deployed resources
terraform show
terraform output

# Switch to production workspace
terraform workspace new prod
terraform workspace select prod

# Plan with prod variables
terraform plan -var-file="prod.tfvars"

# Apply to prod
terraform apply -var-file="prod.tfvars" -auto-approve

# Switch back to dev
terraform workspace select dev

# Destroy dev resources
terraform destroy -var-file="dev.tfvars" -auto-approve

# Destroy prod resources
terraform workspace select prod
terraform destroy -var-file="prod.tfvars" -auto-approve
```

#### Output Information

```bash
# Get instance details
terraform output instance_id
terraform output instance_public_ip
terraform output security_group_id
```

#### SSH into Instance

```powershell
# Get the instance public IP
$ip = (terraform output -raw instance_public_ip)

# SSH to instance (Linux/WSL)
ssh -i C:\Users\YourUsername\.ssh\id_rsa ec2-user@$ip
```

---

### 02_multi_ec2 - Multiple EC2 Instances

**Purpose**: Demonstrates deploying multiple EC2 instances using Terraform's count meta-argument.

**What it deploys:**
- Multiple EC2 instances (configurable)
- Shared security group
- Shared key pair

**Key features:**
- Uses `count` to create multiple resource instances
- Single variable file to manage all instances
- Dynamic resource naming

#### Configuration

**Edit terraform.tfvars:**

```bash
cd 02_multi_ec2
```

```hcl
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "us-east-1"
ami_id         = "ami-0521bc4c70257a054"
instance_type  = "t2.nano"
public_key_path = "C:/Users/YourUsername/.ssh/id_rsa.pub"

# Define instance names
instance_names = ["web-server-1", "web-server-2", "app-server-1"]
```

#### Commands

```powershell
cd 02_multi_ec2

# Initialize
terraform init

# Validate configuration
terraform validate

# Plan infrastructure
terraform plan

# Apply configuration
terraform apply -auto-approve

# View instances created
terraform state list
# Output: 
# aws_instance.ec2_instances[0]
# aws_instance.ec2_instances[1]
# aws_instance.ec2_instances[2]

# Get output information
terraform output instance_ids
terraform output instance_ips

# Destroy specific instance
terraform destroy -target="aws_instance.ec2_instances[0]" -auto-approve

# Destroy all
terraform destroy -auto-approve
```

#### Scaling Instances

To add or remove instances, modify `instance_names` in `terraform.tfvars`:

```hcl
# Add more instances
instance_names = ["web-server-1", "web-server-2", "app-server-1", "db-server-1", "db-server-2"]

# Then run:
terraform plan
terraform apply -auto-approve
```

---

### 03_Terraform_Modules - Modular EC2 and S3

**Purpose**: Introduces Terraform modules concept for code reusability. Demonstrates module creation and usage.

**What it deploys:**
- EC2 instance using reusable module
- S3 bucket using reusable module

**Key features:**
- Reusable module structure
- Separation of concerns
- DRY (Don't Repeat Yourself) principle

#### Module Structure

```
modules/
├── ec2_instance/
│   ├── main.tf          # EC2, Security Group resources
│   ├── variables.tf     # Input variables
│   └── outputs.tf       # Module outputs
│
└── s3_bucket/
    ├── main.tf          # S3 bucket resources
    ├── variable.tf      # Input variables
    └── output.tf        # Module outputs
```

#### Configuration

**Edit terraform.tfvars:**

```hcl
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "us-east-1"
ami_id         = "ami-0521bc4c70257a054"
instance_type  = "t2.nano"
public_key_path = "C:/Users/YourUsername/.ssh/id_rsa.pub"
```

#### Commands

```powershell
cd 03_Terraform_Modules

# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan

# Apply
terraform apply -auto-approve

# View module outputs
terraform output ec2_instance_id
terraform output s3_bucket_name

# Destroy
terraform destroy -auto-approve
```

#### Creating Custom Modules

To create a new module:

```bash
# 1. Create module directory
mkdir -p modules/your_module

# 2. Create required files
# modules/your_module/main.tf
# modules/your_module/variables.tf
# modules/your_module/outputs.tf

# 3. Call module in main.tf
# module "your_module" {
#   source = "./modules/your_module"
#   var1 = value1
#   var2 = value2
# }

# 4. Initialize and apply
terraform init
terraform apply
```

---

### 04_ec2 - Simple EC2 Instance

**Purpose**: Basic EC2 instance deployment with minimal configuration.

**What it deploys:**
- Single EC2 instance

**Files:**
- `main.tf`: Resource definitions
- `input-var.tf`: Variables (instead of variables.tf)
- `out-var.tf`: Outputs (instead of output.tf)

#### Commands

```powershell
cd 04_ec2

# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply -auto-approve

# View outputs
terraform output

# Destroy
terraform destroy -auto-approve
```

---

### 05_DemoEC2 - Demo EC2 Setup

**Purpose**: Demonstration EC2 setup for learning purposes.

**What it deploys:**
- Single EC2 instance with example configuration

**Files:**
- `main.tf`: Configuration
- `input-vars.tf`: Input variables
- `output-vars.tf`: Output variables

#### Commands

```powershell
cd 05_DemoEC2

# Initialize
terraform init

# Apply
terraform apply -auto-approve

# Check outputs
terraform output

# Cleanup
terraform destroy -auto-approve
```

---

### 06-Module - Multi-Module EC2 and S3

**Purpose**: Demonstrates modular architecture with separate EC2 and S3 modules, supporting multiple environments.

**What it deploys:**
- EC2 instance from module
- S3 bucket from module
- Support for dev/prod environments

**Key features:**
- Two separate modules (EC2 and S3)
- Environment-based configuration
- Workspace-based state management

#### Module Structure

```
06-Module/
├── main.tf
├── provider.tf
├── variable.tf
├── output.tf
├── dev.tfvars
├── prod.tfvars
├── EC2/
│   ├── main.tf
│   ├── variable.tf
│   └── output.tf
├── S3/
│   └── (files)
└── terraform.tfstate.d/
    ├── dev/
    └── prod/
```

#### Configuration

**Edit dev.tfvars:**

```hcl
ami = "ami-0521bc4c70257a054"
instance_type = "t2.nano"
key_name = "dev-key"
# Other environment-specific variables
```

**Edit prod.tfvars:**

```hcl
ami = "ami-0521bc4c70257a054"
instance_type = "t2.small"
key_name = "prod-key"
# Other environment-specific variables
```

#### Commands

```powershell
cd 06-Module

# Initialize
terraform init

# Create or switch to dev workspace
terraform workspace new dev
terraform workspace select dev

# Plan dev
terraform plan -var-file="dev.tfvars"

# Apply dev
terraform apply -var-file="dev.tfvars" -auto-approve

# Switch to prod
terraform workspace new prod
terraform workspace select prod

# Plan prod
terraform plan -var-file="prod.tfvars"

# Apply prod
terraform apply -var-file="prod.tfvars" -auto-approve

# View current workspace
terraform workspace list

# Destroy dev
terraform workspace select dev
terraform destroy -var-file="dev.tfvars" -auto-approve

# Destroy prod
terraform workspace select prod
terraform destroy -var-file="prod.tfvars" -auto-approve
```

---

### terraform-enterprise-aws - Enterprise VPC Setup

**Purpose**: Complete enterprise-grade deployment with VPC, security groups, and EC2 instances. Most advanced configuration.

**What it deploys:**
- Custom VPC with public subnet
- Security group with ingress/egress rules
- EC2 instance within the VPC
- Route tables and internet gateway

**Key features:**
- Modular architecture (VPC, Security Group, EC2 modules)
- Remote state backend support
- Multi-environment support (dev/prod)
- Comprehensive variable management
- Complete networking setup

#### Module Structure

```
terraform-enterprise-aws/
├── modules/
│   ├── vpc/
│   │   ├── main.tf        # VPC, Subnet, IGW, Route table
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/
│   │   ├── main.tf        # Security group rules
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf        # EC2 instance
│       ├── variables.tf
│       └── outputs.tf
├── main.tf                # Module calls
├── provider.tf            # AWS provider
├── versions.tf            # Version constraints
├── variables.tf           # Root variables
├── outputs.tf             # Root outputs
├── locals.tf              # Local variables
├── backend.tf             # State backend
├── dev.tfvars             # Dev environment
├── prod.tfvars            # Prod environment
├── backend-dev.hcl        # Dev backend config
└── backend-prod.hcl       # Prod backend config
```

#### Configuration

**Edit dev.tfvars:**

```hcl
region     = "us-east-1"
environment = "dev"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# EC2 Configuration
ami = "ami-0521bc4c70257a054"
instance_type = "t2.nano"
key_name = "dev-key"

project_name = "MyProject"
```

**Edit prod.tfvars:**

```hcl
region     = "us-east-1"
environment = "prod"

# VPC Configuration
vpc_cidr = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"

# EC2 Configuration
ami = "ami-0521bc4c70257a054"
instance_type = "t2.small"
key_name = "prod-key"

project_name = "MyProject"
```

#### Commands - Standard Setup

```powershell
cd terraform-enterprise-aws

# Initialize with default backend
terraform init

# Validate configuration
terraform validate

# Format code (optional but recommended)
terraform fmt -recursive

# Plan infrastructure
terraform plan -var-file="dev.tfvars"

# Apply infrastructure
terraform apply -var-file="dev.tfvars" -auto-approve

# View outputs
terraform output

# Get specific output
terraform output vpc_id
terraform output instance_id
terraform output instance_public_ip

# Destroy infrastructure
terraform destroy -var-file="dev.tfvars" -auto-approve
```

#### Commands - With Remote Backend (Advanced)

If using S3 remote backend for state management:

```powershell
cd terraform-enterprise-aws

# Initialize with dev backend (requires S3 bucket)
terraform init -backend-config="backend-dev.hcl"

# Initialize with prod backend
terraform init -backend-config="backend-prod.hcl"

# Reconfigure backend
terraform init -migrate-state

# View remote state
terraform state list

# Destroy with backend
terraform destroy -var-file="dev.tfvars" -auto-approve
```

#### Using Saved Plans

```powershell
# Create and save a plan
terraform plan -var-file="dev.tfvars" -out="dev.tfplan"

# Verify the plan
terraform show dev.tfplan

# Apply the saved plan
terraform apply dev.tfplan

# This ensures consistency between plan and apply
```

#### VPC and Networking Details

The deployed VPC includes:

```
VPC (10.0.0.0/16 or 10.1.0.0/16)
├── Public Subnet (10.0.1.0/24 or 10.1.1.0/24)
│   └── EC2 Instance
│       └── Elastic IP or Public IP
├── Internet Gateway
└── Route Table
    └── Route: 0.0.0.0/0 → IGW
```

Security Group allows:
- **Inbound**: SSH (port 22) from 0.0.0.0/0
- **Outbound**: All traffic

#### Accessing the Instance

```powershell
# Get outputs
terraform output

# SSH to instance
ssh -i C:\Users\YourUsername\.ssh\id_rsa ec2-user@<public-ip>
```

---

## Commands Reference

### Essential Commands

```bash
# Initialize working directory
terraform init

# Validate configuration
terraform validate

# Format configuration files
terraform fmt

# Format all files recursively
terraform fmt -recursive

# Create execution plan
terraform plan

# Plan with specific variables
terraform plan -var-file="dev.tfvars"

# Save plan to file
terraform plan -out=tfplan

# Apply changes
terraform apply

# Apply without confirmation
terraform apply -auto-approve

# Apply saved plan
terraform apply tfplan

# Apply with specific variables
terraform apply -var-file="dev.tfvars" -auto-approve

# Show current state
terraform show

# Destroy infrastructure
terraform destroy

# Destroy without confirmation
terraform destroy -auto-approve

# Destroy with variables
terraform destroy -var-file="dev.tfvars" -auto-approve
```

### State Management Commands

```bash
# List resources in state
terraform state list

# Show specific resource
terraform state show aws_instance.example

# Remove resource from state (without destroying)
terraform state rm aws_instance.example

# Pull remote state locally
terraform state pull

# Push local state to remote
terraform state push

# Force unlock state (use with caution)
terraform force-unlock LOCK_ID
```

### Workspace Commands

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new workspace-name

# Select workspace
terraform workspace select workspace-name

# Delete workspace
terraform workspace delete workspace-name

# Show current workspace
terraform workspace show
```

### Output and Variable Commands

```bash
# Display all outputs
terraform output

# Display specific output
terraform output output_name

# Display output in raw format (no JSON formatting)
terraform output -raw output_name

# List all variables
terraform var-file="vars.tfvars"

# Validate variables
terraform validate
```

### Debugging Commands

```bash
# Enable debug logging
$env:TF_LOG = "DEBUG"
terraform plan

# Save debug output to file
$env:TF_LOG_PATH = "terraform.log"

# Disable debug logging
$env:TF_LOG = ""

# Show detailed plan in JSON
terraform plan -json

# Graph infrastructure dependencies
terraform graph

# Validate JSON syntax
terraform validate
```

### Advanced Commands

```bash
# Target specific resources (plan only specific resources)
terraform plan -target=aws_instance.example

# Apply to specific resources only
terraform apply -target=aws_instance.example -auto-approve

# Refresh state (sync with actual infrastructure)
terraform refresh

# Import existing infrastructure
terraform import aws_instance.example i-1234567890abcdef0

# Taint resource (mark for recreation)
terraform taint aws_instance.example

# Untaint resource
terraform untaint aws_instance.example

# Terraform version
terraform version

# Get module source
terraform get

# Update modules
terraform get -update
```

---

## State Management

### Understanding Terraform State

**State File**: A JSON file that Terraform creates to track deployed resources and their current configuration. Essential for Terraform to know what exists and what to change.

**State File Location**: `terraform.tfstate` in the project directory

### State File Security

⚠️ **IMPORTANT**: State files contain sensitive information!

**Never:**
- Commit state files to Git
- Share state files publicly
- Expose state files in logs

**Always:**
- Add `terraform.tfstate*` to `.gitignore`
- Use remote backends for production
- Encrypt state files at rest
- Restrict access to state files
- Use state locking mechanisms

#### .gitignore for Terraform

```bash
# Create or update .gitignore
# Ignore state files
terraform.tfstate
terraform.tfstate.*
terraform.tfstate.backup

# Ignore plan files
*.tfplan

# Ignore cached modules
.terraform/

# Ignore crash log files
crash.log
crash.*.log

# Ignore lock files (optional - some teams commit these)
# .terraform.lock.hcl

# Ignore override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Ignore IDE files
.vscode/
.idea/
*.swp
*.swo

# Ignore OS files
.DS_Store
Thumbs.db
```

### Remote State Backends

For production:

#### S3 Backend Example

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

Commands:

```bash
# Initialize with S3 backend
terraform init

# Migrate local state to S3
terraform init -migrate-state

# View S3 state
terraform state list
```

### State Commands

```bash
# Backup state
Copy-Item terraform.tfstate terraform.tfstate.backup

# Restore from backup
Copy-Item terraform.tfstate.backup terraform.tfstate

# Pull state from backend
terraform state pull > state.backup

# Push state to backend
terraform state push state.backup

# Lock state manually
terraform state lock

# Unlock state
terraform force-unlock LOCK_ID
```

---

## Best Practices

### 1. Code Organization

```bash
# Organize by environment
├── dev/
│   ├── main.tf
│   ├── variables.tfvars
│   └── terraform.tfstate
└── prod/
    ├── main.tf
    ├── variables.tfvars
    └── terraform.tfstate

# Or organize by component
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── security-group/
├── dev/
├── prod/
└── staging/
```

### 2. Variable Management

**Good practices:**
- Use `terraform.tfvars` for sensitive values
- Use `.tfvars.example` for documentation
- Define all variables with descriptions
- Use appropriate variable types
- Provide sensible defaults

**Example:**

```hcl
variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t2.nano"

  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must be t2 or t3 family."
  }
}
```

### 3. Resource Naming

```hcl
# Use consistent naming convention
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
    Project     = var.project_name
    CreatedBy   = "Terraform"
    CreatedDate = timestamp()
  }
}
```

### 4. Module Best Practices

```hcl
# Module structure
modules/
└── my_module/
    ├── main.tf              # Resources
    ├── variables.tf         # Input variables with descriptions
    ├── outputs.tf           # Output values with descriptions
    ├── locals.tf            # Local calculations
    └── README.md            # Module documentation

# Module call with clear intent
module "web_server" {
  source = "./modules/ec2"
  
  # Required variables
  instance_type = var.instance_type
  key_name      = var.key_name
  
  # Optional with defaults
  environment = var.environment
  tags        = local.common_tags
}
```

### 5. Documentation

Create module READMEs:

```markdown
# EC2 Module

## Overview
This module creates an EC2 instance with... with optional... 

## Usage
```hcl
module "web_server" {
  source = "./modules/ec2"
  
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name
}
```

## Variables
| Name | Type | Required | Description |
|------|------|----------|-------------|
| ami | string | yes | AMI ID |
| instance_type | string | no | Instance type (default: t2.nano) |

## Outputs
| Name | Description |
|------|-------------|
| instance_id | EC2 instance ID |
| public_ip | Public IP address |
```

### 6. Version Control

```bash
# Initialize git
git init

# Add .gitignore
echo "terraform.tfstate*" > .gitignore
echo ".terraform/" >> .gitignore
echo "crash.log" >> .gitignore

# Commit code
git add -A
git commit -m "Initial Terraform configuration"

# Push to repository
git push origin main
```

### 7. Pre-deployment Checklist

Before applying:

```bash
# ✓ Validate syntax
terraform validate

# ✓ Format code
terraform fmt -recursive

# ✓ Review plan thoroughly
terraform plan -var-file="dev.tfvars"

# ✓ Check for hardcoded secrets
grep -r "password\|secret\|token" .

# ✓ Verify variables
cat dev.tfvars

# ✓ Check state file is not committed
grep -l "terraform.tfstate" .git/

# ✓ Review changes with team
# (share plan output for review)

# ✓ Apply
terraform apply tfplan
```

### 8. Monitoring and Logging

```bash
# Enable debug logging
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform.log"

# Run any command
terraform plan

# Review logs
Get-Content terraform.log

# Disable logging
$env:TF_LOG = ""
```

### 9. Backup Strategy

```bash
# Backup before destroying
Copy-Item terraform.tfstate "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').tfstate"

# Backup state to cloud storage
Copy-Item terraform.tfstate s3://backup-bucket/

# Version control backups
git add backup-*.tfstate
git commit -m "State backup"
```

### 10. Cost Management

```hcl
# Use cost-effective instance types
variable "instance_type" {
  type    = string
  default = "t2.nano"  # Free tier eligible
}

# Stop instances when not needed
resource "aws_instance" "dev_server" {
  disable_api_termination = false
  
  tags = {
    Schedule = "stop-after-hours"
  }
}

# Use spot instances for non-critical workloads
resource "aws_instance" "batch_processor" {
  instance_market_options {
    market_type = "spot"
  }
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. AWS Credentials Not Found

**Error**: `Error: error configuring Terraform AWS Provider: no valid credential sources found`

**Solution**:

```powershell
# Check credentials file exists
Test-Path "$env:USERPROFILE\.aws\credentials"

# Re-configure AWS CLI
aws configure

# Verify credentials
aws sts get-caller-identity

# Or set environment variables temporarily
$env:AWS_ACCESS_KEY_ID = "YOUR_KEY"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_SECRET"
$env:AWS_DEFAULT_REGION = "us-east-1"
```

#### 2. Provider Plugin Not Found

**Error**: `Error: Unsupported block type`

**Solution**:

```powershell
# Reinitialize
terraform init

# Update provider
terraform init -upgrade

# Check lock file
Get-Content .terraform.lock.hcl
```

#### 3. State Lock Timeout

**Error**: `Error: Error: error acquiring the state lock`

**Solution**:

```powershell
# List locks
terraform state list

# Force unlock (use carefully)
terraform force-unlock LOCK_ID

# Or remove lock file
Remove-Item .terraform.tfstate.lock.info -Force
```

#### 4. SSH Key Not Found

**Error**: `Error: file() file not found`

**Solution**:

```powershell
# Check key exists
Test-Path "C:\Users\YourUsername\.ssh\id_rsa.pub"

# If not, generate new key
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa -N ""

# Update in variables/tfvars
# public_key_path = "C:/Users/YourUsername/.ssh/id_rsa.pub"
```

#### 5. Insufficient Permissions

**Error**: `Error: User: arn:aws:iam::... is not authorized`

**Solution**:

```bash
# Check IAM permissions
aws iam get-user

# Attach required policies
# 1. Go to AWS Console
# 2. IAM > Users > Select user
# 3. Attach these policies:
#    - AmazonEC2FullAccess
#    - AmazonS3FullAccess
#    - AmazonVPCFullAccess

# Verify permissions
aws ec2 describe-instances
```

#### 6. Resource Already Exists

**Error**: `Error: error creating security group: InvalidGroup.Duplicate`

**Solution**:

```powershell
# Import existing resource
terraform import aws_security_group.existing sg-12345678

# Or destroy and recreate
terraform destroy -auto-approve
terraform apply -auto-approve

# Or use terraform import
terraform import aws_instance.example i-1234567890abcdef0
```

#### 7. Invalid AMI ID

**Error**: `Error: Error: InvalidAMIID.NotFound`

**Solution**:

```bash
# Find correct AMI ID for your region
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*" --query 'Images[0].ImageId' --region us-east-1

# Update in variables
ami_id = "ami-0521bc4c70257a054"

# List all available Amazon Linux 2 AMIs
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*" --region us-east-1 --query 'Images[].{Name:Name,ID:ImageId}' --output table
```

#### 8. Terraform Version Mismatch

**Error**: `Error: Unsupported Terraform Version`

**Solution**:

```powershell
# Check current version
terraform version

# Update Terraform
choco upgrade terraform

# Install specific version
choco install terraform --version 1.5.0

# Update version constraint in versions.tf
# required_version = ">= 1.5.0"

# Reinitialize
terraform init
```

#### 9. Invalid Configuration

**Error**: `Error: Invalid or missing required argument`

**Solution**:

```bash
# Validate configuration
terraform validate

# Check for typos in resource names
Get-Content main.tf

# Review required variables
Get-Content variables.tf

# Check tfvars file
Get-Content terraform.tfvars

# Run validate with verbose
terraform validate -json
```

#### 10. State File Corruption

**Error**: `Error: Failed to read state file`

**Solution**:

```powershell
# Restore from backup
Copy-Item terraform.tfstate.backup terraform.tfstate

# Backup state
Copy-Item terraform.tfstate terraform.tfstate.corrupted

# Refresh state (sync with actual infrastructure)
terraform refresh

# Pull state from remote backend
terraform state pull > state.json

# Push state
terraform state push state.json
```

### Debugging Commands

```bash
# Enable verbose logging
$env:TF_LOG = "DEBUG"

# Save to file
$env:TF_LOG_PATH = "terraform-debug.log"

# Run any terraform command
terraform plan

# View logs
Get-Content terraform-debug.log

# Disable logging
$env:TF_LOG = ""

# JSON output for programmatic parsing
terraform plan -json | convertfrom-json

# Check resource dependencies
terraform graph | Out-File graph.dot

# Show all interpolations
terraform console
```

### Getting Help

1. **Official Documentation**: https://www.terraform.io/docs
2. **AWS Documentation**: https://docs.aws.amazon.com
3. **Terraform Registry**: https://registry.terraform.io
4. **Community Forums**: https://discuss.hashicorp.com/c/terraform/
5. **Stack Overflow**: Tag with `terraform`
6. **GitHub Issues**: https://github.com/hashicorp/terraform/issues

---

## Quick Start Examples

### Deploy Single EC2 Instance (Fastest Way)

```powershell
cd 04_ec2
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

# Get public IP
terraform output instance_public_ip

# Clean up
terraform destroy -auto-approve
```

### Deploy Multiple EC2 Instances

```powershell
cd 02_multi_ec2

# Edit terraform.tfvars
# instance_names = ["web-1", "web-2", "app-1"]

terraform init
terraform apply -auto-approve

# View all instances
terraform state list

# Destroy all
terraform destroy -auto-approve
```

### Deploy Enterprise VPC Setup

```powershell
cd terraform-enterprise-aws

# Initialize
terraform init

# Plan
terraform plan -var-file="dev.tfvars"

# Apply
terraform apply -var-file="dev.tfvars" -auto-approve

# Get outputs
terraform output

# Destroy
terraform destroy -var-file="dev.tfvars" -auto-approve
```

---

## Security Considerations

### 1. Never Hardcode Credentials

❌ **Bad:**
```hcl
provider "aws" {
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}
```

✅ **Good:**
```hcl
provider "aws" {
  region = var.aws_region
  # Uses AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env vars
  # Or credentials from ~/.aws/credentials
}
```

### 2. Encrypt Sensitive Variables

Use AWS Secrets Manager or Parameter Store:

```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "database" {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}
```

### 3. Use IAM Roles Instead of Keys

```hcl
# For EC2 instances - use IAM instance profile
resource "aws_instance" "web_server" {
  iam_instance_profile = aws_iam_instance_profile.web_profile.name
}

resource "aws_iam_instance_profile" "web_profile" {
  role = aws_iam_role.web_role.name
}

resource "aws_iam_role" "web_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
```

### 4. Use Separate AWS Accounts for Different Environments

- Development account
- Staging account  
- Production account

Each with dedicated IAM users and separate credentials.

### 5. Enable MFA for Root Account and Privileged Users

### 6. Audit Trail and Logging

Enable AWS CloudTrail for all API calls:

```hcl
resource "aws_cloudtrail" "main" {
  depends_on                = [aws_s3_bucket_policy.bucket_policy]
  name                      = "main"
  s3_bucket_name            = aws_s3_bucket.log_bucket.id
  include_global_events     = true
  is_multi_region_trail     = true
  enable_log_file_validation = true
  depends_on               = [aws_s3_bucket_policy.bucket_policy]
}
```

### 7. Regular Security Scanning

```bash
# Use Checkov for Terraform security scanning
pip install checkov
checkov -d . --framework terraform

# Use TFLint for code quality
choco install tflint
tflint --init
tflint
```

---

## Performance Tips

### 1. Parallel Operations

```bash
# Increase parallelism (default is 10)
terraform apply -parallelism=50
```

### 2. Use Target to Apply Specific Resources

```bash
# Faster than full apply when testing single resource
terraform apply -target=aws_instance.web_server -auto-approve
```

### 3. Use Local Caching

```bash
# Keep .terraform directory in version control (large but speeds up init)
git add .terraform.lock.hcl
```

### 4. Optimize Module Structure

Keep modules focused and minimal:

```hcl
# Good - focused module
module "ec2_instance" {
  source = "./modules/ec2"
  # 5-10 variables
}

# Bad - module does too much
module "everything" {
  source = "./modules/all"
  # 50+ variables
}
```

### 5. Use Data Sources for Read-Only Operations

```hcl
# Efficient - no state tracking
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}

# Use in resource
resource "aws_instance" "server" {
  ami = data.aws_ami.amazon_linux.id
}
```

---

## File Change Summary

If you're starting fresh with this workspace, here's what you need to do for each project:

| Project | Action | Required Changes |
|---------|--------|------------------|
| 01_EC2 | Dev/Prod Deploy | Update public_key_path in .tfvars |
| 02_multi_ec2 | Multi-instance | Update credentials and key path in terraform.tfvars |
| 03_Terraform_Modules | Modular Deploy | Update credentials and key path in terraform.tfvars |
| 04_ec2 | Quick Deploy | Update key path in input-var.tf |
| 05_DemoEC2 | Demo | Update key path in input-vars.tf |
| 06-Module | Modular Env | Update credentials in dev/prod.tfvars |
| terraform-enterprise-aws | Enterprise | Update credentials in provider.tf or env vars |

---

## Additional Resources

- **Terraform Language**: https://www.terraform.io/language
- **AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest
- **Terraform Best Practices**: https://www.terraform.io/cloud-docs/recommended-practices
- **AWS Free Tier**: https://aws.amazon.com/free
- **SSH Key Setup**: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

---

## Support and Contributing

For issues with specific projects:

1. Check the Troubleshooting section above
2. Run `terraform validate` to check for syntax errors
3. Enable debug logging with `$env:TF_LOG = "DEBUG"`
4. Check AWS console to verify resource limits
5. Review CloudTrail logs for AWS API errors

---

**Last Updated**: February 14, 2026
**Terraform Version**: >= 1.5.0
**AWS Provider Version**: ~> 5.0

---

*This README covers all aspects of deploying and managing AWS infrastructure with Terraform. Refer to official documentation for the latest updates and features.*
