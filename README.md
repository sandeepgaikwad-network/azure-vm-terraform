# Azure Virtual Machine Deployment with Terraform

This repository contains step-by-step Terraform configurations to deploy an Azure Virtual Machine in Microsoft Azure.  
Each stage is modular, documented, and follows best practices for clarity, governance, and scalability.

---

## Terraform script for creating all the resources step by step

Step 1: Resource Group

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-project-dev-southindia"
  location = var.location

  tags = {
    Owner       = "Sandeep Gaikwad"
    Environment = var.environment
    Project     = var.project_name
  }
}

📝 Notes
Purpose: Resource Groups are logical containers for Azure resources.
Use: Helps organize resources by project, environment, and region.
Best Practice: Apply tags for governance, cost tracking, and ownership.

Step 2: Virtual Network & Subnet

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.environment}-southindia"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.project_name}-${var.environment}-southindia"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

📝 Notes
Purpose: Provides private networking for the VM.
Use: Subnets allow segmentation of workloads.
Best Practice: Use non-overlapping CIDR ranges to avoid conflicts.