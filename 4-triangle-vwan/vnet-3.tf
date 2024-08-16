# https://blog.pichuang.com.tw/azure-subnets.html

resource "azurerm_virtual_network" "vnet-3" {
  address_space       = ["10.33.33.0/24"]
  location            = var.vhub-3-region
  name                = "vnet-spoke-${var.vhub-3-region}"
  resource_group_name = var.lab-rg

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}
resource "azurerm_subnet" "subnet-vm-3" {
  name                 = "subnet-vm-${var.vhub-3-region}"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet-3.name
  address_prefixes     = ["10.33.33.0/27"]

}

resource "azurerm_virtual_hub_connection" "conn-vhub-3-to-vwan" {
  name                      = "conn-vhub-3-to-vwan"
  virtual_hub_id            = azurerm_virtual_hub.vhub-3.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-3.id
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg-vnet-3" {
  name                = "nsg-vnet-${var.vhub-3-region}"
  location            = var.vhub-3-region
  resource_group_name = var.lab-rg

  security_rule {
    name                       = "Allow-inbound-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-inbound-icmp"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "Allow-outbound-any"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
}

resource "azurerm_public_ip" "public-ip-vnet-3" {
  name                = "public-ip-${var.vhub-3-region}"
  location            = var.vhub-3-region
  resource_group_name = var.lab-rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# Create network interface card
resource "azurerm_network_interface" "nic-vnet-3" {
  name                = "nic-${var.vhub-3-region}"
  location            = var.vhub-3-region
  resource_group_name = var.lab-rg
  accelerated_networking_enabled = true
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig-nic-vm-${var.vhub-3-region}"
    subnet_id                     = azurerm_subnet.subnet-vm-3.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.33.33.4"
    public_ip_address_id          = azurerm_public_ip.public-ip-vnet-3.id

  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "connect-nsg-and-nic-hub-3" {
  network_interface_id      = azurerm_network_interface.nic-vnet-3.id
  network_security_group_id = azurerm_network_security_group.nsg-vnet-3.id
}

resource "azurerm_linux_virtual_machine" "vm-hub-3" {
  name                  = "vm-${var.vhub-3-region}"
  location              = var.vhub-3-region
  resource_group_name   = var.lab-rg
  network_interface_ids = [azurerm_network_interface.nic-vnet-3.id]
  size                  = "Standard_D2_v5"

  os_disk {
    name                 = "disk-vm-${var.vhub-3-region}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm-${var.vhub-3-region}"
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username   = var.admin_username

    public_key = file("~/.ssh/poc-ms.pub")
  }

  custom_data = filebase64("cloud-init.txt")

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sa-boot-diagnostics-3.primary_blob_endpoint
  }
}

resource "random_string" "suffix-3" {
  length  = 10
  special = false
  upper = false
}

resource "azurerm_storage_account" "sa-boot-diagnostics-3" {
  name                     = "triangle${random_string.suffix-3.result}"
  resource_group_name      = var.lab-rg
  location                 = var.vhub-3-region
  account_kind = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Hot"
  allow_nested_items_to_be_public = true
  public_network_access_enabled = true

  blob_properties {
    versioning_enabled = false
  }
}
