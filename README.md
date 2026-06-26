# Azure Virtual Machine Deployment with Terraform

This repository contains step-by-step Terraform configurations to deploy an Azure Virtual Machine in Microsoft Azure.  
Each stage is modular, documented, and follows best practices for clarity, governance, and scalability.

---

## Step 1: Resource Group

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