# Multi-Tenant Infra via Terraform

This repository showcases a fully-automated, production-aligned **multi-tenant infrastructure** built using **Terraform**. Each tenant is deployed in an isolated AWS VPC with its own compute stack, SSL termination, and optional DNS routing. Designed with scalability, security, and modularity in mind.

---

##  Features

*  Isolated VPC, subnet, and EC2 per tenant
*  Per-tenant Application Load Balancer (ALB) with HTTPS (self-signed cert)
*  NGINX web server with user data bootstrap
*  DNS-ready (supports Route53 or external domains)
*  Modular Terraform codebase
*  Workspace-based multi-tenant lifecycle management

---

##  Deployment Instructions

### 1.  Pre-Requisites

* AWS CLI configured (`aws configure`)
* Terraform >= 1.4+
* IAM user/role with necessary permissions (VPC, EC2, ACM, IAM, etc.)

### 2.  SSH Key Setup

Use the scripts provided in the `scripts/` directory:

```bash
# Generate and import SSH key to AWS
./scripts/generate_ssh_key.sh
# OR for Windows
./scripts/generate_ssh_key.ps1
```

This will:

* Create a new SSH key pair locally
* Import the public key into AWS EC2 key pairs

Update your `.tfvars` files accordingly with the key name.

---

### 3.  Initialize Terraform Modules

```bash
terraform init
```

---

### 4.  Deploy a Tenant

Create a dedicated workspace for each tenant:

```bash
# For tenant1
terraform workspace new tenant1 || terraform workspace select tenant1
terraform apply -var-file="tenants/tenant1.tfvars"

# For tenant2
terraform workspace new tenant2 || terraform workspace select tenant2
terraform apply -var-file="tenants/tenant2.tfvars"
```

Each tenant's variables (VPC CIDR, key name, AMI, etc.) should be configured in its `.tfvars` file under the `tenants/` folder.

---

### 5.  Access the Application

After apply completes, Terraform will output the ALB DNS URL:


Outputs:
  tenant_url = https://archium-alb-xxxxx.us-east-1.elb.amazonaws.com


Use this URL to verify HTTPS access to the tenant-specific NGINX app.

---

##  Project Structure

├── modules/
│   ├── vpc
│   ├── compute
│   ├── alb
│   ├── dns
│   └── ssl
├── tenants/
│   ├── tenant1.tfvars
│   └── tenant2.tfvars
├── scripts/
│   ├── generate_ssh_key.sh
│   └── generate_ssh_key.ps1
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md


---

##  Example `.tfvars` for a Tenant

**tenant**            = "archium"                         # Unique name for this tenant (used in resource naming)

**domain**            = "archium.localdemo.com"           # (Optional) DNS subdomain if using Route53 or external DNS

**cidr_block**        = "10.10.0.0/16"                     # CIDR block for tenant's VPC

**aws_region**        = "us-east-1"                       # AWS region to deploy in

**ami_id**            = "ami-05ffe3c48a9991133"           # AMI ID for EC2 (Amazon Linux 2023 w/ SSM support)

**instance_type**     = "t2.micro"                        # EC2 instance type

**key_name**          = "devops-key"                      # Name of existing EC2 key pair (used for SSH/SSM)

**public_key_path**   = "C:/Users/you/.ssh/devops-key.pub" # Path to your SSH public key (used to import if needed)

**route53_zone_id**   = "Z123456789EXAMPLE"               # (Optional) Route53 Zone ID if using hosted zone for DNS


###  Notes:

* `ami_id`: Use one that supports your OS and architecture (Amazon Linux preferred for SSM).
* `key_name`: Ensure this matches the key imported via your `scripts/generate_ssh_key.sh` or manually in AWS Console.
* `route53_zone_id`: Optional for now, but needed if automating DNS (can be omitted in current demo setup).

---

##  Notes

* SSL certs are **self-signed** in this demo. For production, use ACM or Let's Encrypt.
* Each tenant can be upgraded to run in ECS/EKS as a future enhancement.
* Route53 DNS is supported if a registered domain is available.

---

## 🤝 Contributions & Feedback

This project was designed as part of a DevOps architecture challenge. Feel free to raise issues or fork it for experimentation.

**Author:** Sumanth M
**Date:** 06-July 2025

---

Happy multi-tenant scaling! ☁️
