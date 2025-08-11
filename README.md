# Terraform AWS Modules

Reusable Terraform modules for AWS infrastructure deployment.

## Available Modules

### VPC Module
- Creates VPC with public/private subnets
- Configurable CIDR blocks and availability zones
- Internet gateway and routing tables

### Usage

```hcl
module "vpc" {
  source = "git::https://github.com/username/terraform-aws-modules.git//modules/vpc?ref=v1.0.0"
  
  vpc_cidr               = "10.0.0.0/16"
  availability_zones     = ["us-west-2a", "us-west-2b"]
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.10.0/24", "10.0.20.0/24"]
  
  tags = {
    Environment = "dev"
    Project     = "terraform-assignment"
  }
}
```

## Versioning

This repository uses semantic versioning. Use specific version tags when referencing modules.