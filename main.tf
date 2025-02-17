# Configuração da Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }


}
provider "azurerm" {
  features {}
}
# Prefixo 
variable "prefix" {
  default = "prj-minsait"
}
# Resource grupo
resource "azurerm_resource_group" "rg-prj" {
  name     = "rg-${var.prefix}"
  location = "Brazil South"
}
# Resource Vnet
resource "azurerm_virtual_network" "vnet-prj" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-prj.location
  resource_group_name = azurerm_resource_group.rg-prj.name
}
# Resource SubNet
resource "azurerm_subnet" "sub-prj" {
  name                 = "sub-${var.prefix}"
  resource_group_name  = azurerm_resource_group.rg-prj.name
  virtual_network_name = azurerm_virtual_network.vnet-prj.name
  address_prefixes     = ["10.0.2.0/24"]
}
# Resource Pip
resource "azurerm_public_ip" "pip-prj" {
  name                = "pip-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg-prj.name
  location            = azurerm_resource_group.rg-prj.location
  allocation_method   = "Static"
}
# Resource Nic + Ip público
resource "azurerm_network_interface" "nic-prj" {
  name                = "nic-${var.prefix}"
  location            = azurerm_resource_group.rg-prj.location
  resource_group_name = azurerm_resource_group.rg-prj.name

  ip_configuration {
    name                          = "ip-${var.prefix}"
    subnet_id                     = azurerm_subnet.sub-prj.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-prj.id
  }
}
# Resource Vm
resource "azurerm_linux_virtual_machine" "vm-linux-prj" {
  name                  = "vm-linux-${var.prefix}"
  location              = azurerm_resource_group.rg-prj.location
  resource_group_name   = azurerm_resource_group.rg-prj.name
  network_interface_ids = [azurerm_network_interface.nic-prj.id]
  size                  = "Standard_B1s"
  admin_username        = "simeia-macedo"
  admin_password        = "Simeia@123"
  computer_name         = "simeia-server"
  custom_data           = base64encode(file("C:\\Codes\\prj_teste\\config.sh"))


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    name              = "os-disc-linux-${var.prefix}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    disable_password_authentication = false

  tags = {
    environment = "ambiente-de-teste"
  }
}
