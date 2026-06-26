#!/bin/bash
# Azure Virtual Machine Deployment with Terraform
# Author: Sandeep Gaikwad
# Purpose: Step-by-step setup of Azure VM using Terraform

# -----------------------------
# Step 1: Resource Group
# -----------------------------
# Purpose: Logical container for Azure resources
# Use: Organizes resources by project, environment, and region
# Best Practice: Apply tags for governance and cost tracking

cat > resource_group.tf <<EOF
resource "azurerm_resource_group" "rg" {
  name     = "rg-project-dev-southindia"
  location = var.location

  tags = {
    Owner       = "Sandeep Gaikwad"
    Environment = var.environment
    Project     = var.project_name
  }
}
EOF

# -----------------------------
# Step 2: Virtual Network & Subnet
# -----------------------------
# Purpose: Provides private networking for the VM
# Use: Subnets allow segmentation of workloads
# Best Practice: Use non-overlapping CIDR ranges

cat > vnet_subnet.tf <<EOF
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
EOF

# -----------------------------
# Step 3: Network Security Group (NSG)
# -----------------------------
# Purpose: Firewall for the VM
# Use: Controls inbound/outbound traffic
# Best Practice: Only open required ports

cat > nsg.tf <<EOF
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.project_name}-${var.environment}-southindia"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}
EOF

# -----------------------------
# Step 4: Public IP
# -----------------------------
# Purpose: Provides external connectivity
# Use: Required for remote access
# Best Practice: Use static IPs for production workloads

cat > public_ip.tf <<EOF
resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.project_name}-${var.environment}-southindia"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
EOF

# -----------------------------
# Step 5: Network Interface (NIC)
# -----------------------------
# Purpose: Connects VM to subnet and public IP
# Use: Acts as the VM’s network card
# Best Practice: Attach NSG to NIC or subnet

cat > network_interface.tf <<EOF
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.project_name}-${var.environment}-southindia"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
EOF

# -----------------------------
# Step 6: Virtual Machine
# -----------------------------
# Purpose: Core compute resource
# Use: Runs workloads in Azure
# Best Practice: Use SSH keys instead of passwords

cat > virtual_machine.tf <<EOF
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.project_name}-${var.environment}-southindia"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    name                 = "osdisk-${var.project_name}-${var.environment}-southindia"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }
}
EOF

# -----------------------------
# Deployment Instructions
# -----------------------------
# Authenticate with Azure
az login

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply
