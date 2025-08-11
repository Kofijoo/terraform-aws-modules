terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Ubuntu 24.04 LTS AMI (eu-north-1)
locals {
  ubuntu_ami_id = "ami-042b4708b1d05f512"
}

# VPC Module
module "vpc" {
  source = "../modules/vpc"
  
  vpc_cidr               = "10.0.0.0/16"
  availability_zones     = ["eu-north-1a", "eu-north-1b"]
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  
  tags = {
    Environment   = "test"
    Project       = "terraform-assignment"
    Owner         = "DevOps-Team"
    CostCenter    = "Engineering"
    ManagedBy     = "Terraform"
    CreatedDate   = "2024-12-19"
    Purpose       = "Infrastructure-Learning"
  }
}

# Web Server Security Group
module "web_sg" {
  source = "../modules/security-group"
  
  name        = "web-server-sg"
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from internet"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS from internet"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH from internet"
    }
  ]
  
  tags = {
    Environment   = "test"
    Project       = "terraform-assignment"
    Owner         = "DevOps-Team"
    CostCenter    = "Engineering"
    ManagedBy     = "Terraform"
    CreatedDate   = "2024-12-19"
    Purpose       = "Web-Security"
  }
}

# Database Security Group
module "db_sg" {
  source = "../modules/security-group"
  
  name        = "database-sg"
  description = "Security group for database servers"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "MySQL from VPC"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "SSH from VPC"
    }
  ]
  
  tags = {
    Environment   = "test"
    Project       = "terraform-assignment"
    Owner         = "DevOps-Team"
    CostCenter    = "Engineering"
    ManagedBy     = "Terraform"
    CreatedDate   = "2024-12-19"
    Purpose       = "Database-Security"
  }
}

# Web Server EC2 Instance
module "web_server" {
  source = "../modules/ec2"
  
  instance_count              = 1
  instance_type              = "t3.micro"
  ami_id                     = local.ubuntu_ami_id
  subnet_ids                 = module.vpc.public_subnet_ids
  security_group_ids         = [module.web_sg.security_group_id]
  associate_public_ip_address = true
  
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Web Server - Terraform Assignment</h1>" > /var/www/html/index.html
  EOF
  
  tags = {
    Environment   = "test"
    Project       = "terraform-assignment"
    Role          = "web-server"
    Owner         = "DevOps-Team"
    CostCenter    = "Engineering"
    ManagedBy     = "Terraform"
    CreatedDate   = "2024-12-19"
    Purpose       = "Frontend-Service"
    Backup        = "Required"
  }
}

# Database Server EC2 Instance
module "db_server" {
  source = "../modules/ec2"
  
  instance_count              = 1
  instance_type              = "t3.micro"
  ami_id                     = local.ubuntu_ami_id
  subnet_ids                 = module.vpc.private_subnet_ids
  security_group_ids         = [module.db_sg.security_group_id]
  associate_public_ip_address = false
  
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y mariadb-server
    systemctl start mariadb
    systemctl enable mariadb
  EOF
  
  tags = {
    Environment   = "test"
    Project       = "terraform-assignment"
    Role          = "database-server"
    Owner         = "DevOps-Team"
    CostCenter    = "Engineering"
    ManagedBy     = "Terraform"
    CreatedDate   = "2024-12-19"
    Purpose       = "Data-Storage"
    Backup        = "Critical"
    Compliance    = "Required"
  }
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "web_server_public_ip" {
  value = module.web_server.public_ips[0]
}

output "web_server_url" {
  value = "http://${module.web_server.public_ips[0]}"
}

output "db_server_private_ip" {
  value = module.db_server.private_ips[0]
}