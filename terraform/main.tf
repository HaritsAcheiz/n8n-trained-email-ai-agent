# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.subscription_id
}

# Use an existing resource group
data "azurerm_resource_group" "canadacentral-rg" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

# Create a virtual network
resource "azurerm_virtual_network" "magiccars-vnet" {
  name                = "magiccars-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
}

# Create a subnet
resource "azurerm_subnet" "magiccars-subnet" {
  name                 = "magiccars-subnet"
  resource_group_name  = data.azurerm_resource_group.canadacentral-rg.name
  virtual_network_name = azurerm_virtual_network.magiccars-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "magiccars-ip" {
  name                = "magiccars-ip"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
  allocation_method   = "Static"
}

# Create a Network Security Group (NSG) to secure the VM
resource "azurerm_network_security_group" "magiccars-nsg" {
  name                = "magiccars-nsg"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_address_prefix
    destination_address_prefix = "*"
  }
}

# Create a network interface
resource "azurerm_network_interface" "magiccars-nic" {
  name                = "magiccars-nic"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
  ip_configuration {
    name                          = "magiccars-ipconfig"
    subnet_id                     = azurerm_subnet.magiccars-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.magiccars-ip.id
  }
}

# Associate the NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "magiccars-nic-nsg-association" {
  network_interface_id      = azurerm_network_interface.magiccars-nic.id
  network_security_group_id = azurerm_network_security_group.magiccars-nsg.id
}

# Create the linux VM
resource "azurerm_linux_virtual_machine" "n8n-magiccars-vm" {
  name                            = "n8n-magiccars-vm"
  resource_group_name             = data.azurerm_resource_group.canadacentral-rg.name
  location                        = data.azurerm_resource_group.canadacentral-rg.location
  size                            = "Standard_B2s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  network_interface_ids = [
    azurerm_network_interface.magiccars-nic.id,
  ]

  # admin_ssh_key {
  #   username   = var.admin_username
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }
}

# Create a azure key vault
resource "azurerm_key_vault" "magiccars-kv" {
  name                = "magiccars-kv"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                 = "standard"
  purge_protection_enabled = true
}

# Set access policy for the current user
resource "azurerm_key_vault_access_policy" "magiccars-kv-access-policy" {
  key_vault_id = azurerm_key_vault.magiccars-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

# Create a storage account
resource "azurerm_storage_account" "magiccars-sa" {
  name                     = "magiccarssa"
  location                 = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name      = data.azurerm_resource_group.canadacentral-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Azure AI Services
resource "azurerm_ai_services" "magiccars-ais" {
  name                = "magiccars-ais"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
  sku_name            = "S0"
}

# Create Azure AI Foundry
resource "azurerm_ai_foundry" "magiccars-aif" {
  name                = "magiccars-aif"
  location            = data.azurerm_resource_group.canadacentral-rg.location
  resource_group_name = data.azurerm_resource_group.canadacentral-rg.name
  storage_account_id  = azurerm_storage_account.magiccars-sa.id
  key_vault_id        = azurerm_key_vault.magiccars-kv.id
  identity {
    type = "SystemAssigned"
  }
}

# Create Azure AI Foundry Project
resource "azurerm_ai_foundry_project" "magiccars-aif-project" {
  name               = "magiccars-aif-project"
  location           = azurerm_ai_foundry.magiccars-aif.location
  ai_services_hub_id = azurerm_ai_foundry.magiccars-aif.id
  identity {
    type = "SystemAssigned"
  }
}