
resource "azurerm_public_ip" "public-ip-bastion-z" {
  name                = "pip-bastion"
  location            = var.vhub-1-region
  resource_group_name = var.lab-rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# Create network interface card
resource "azurerm_network_interface" "nic-bastion" {
  name                           = "nic-bastion"
  location                       = var.vhub-1-region
  resource_group_name            = var.lab-rg
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true

  ip_configuration {
    name                          = "ipconfig-nic-vm-bastion"
    subnet_id                     = azurerm_subnet.subnet-vm-1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.3.3.5"
    public_ip_address_id          = azurerm_public_ip.public-ip-bastion-z.id

  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "connect-nsg-and-nic-hub-bastion" {
  network_interface_id      = azurerm_network_interface.nic-bastion.id
  network_security_group_id = azurerm_network_security_group.nsg-vnet-1.id
}

resource "azurerm_linux_virtual_machine" "vm-hub-bastion" {
  name                  = "vm-bastion"
  location              = var.vhub-1-region
  resource_group_name   = var.lab-rg
  network_interface_ids = [azurerm_network_interface.nic-bastion.id]
  size                  = "Standard_D2_v5"

  os_disk {
    name                 = "disk-vm-bastion"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm-bastion"
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username = var.admin_username

    public_key = file("repairman_rsa.pub")
  }

  custom_data = filebase64("cloud-init.txt")

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sa-boot-diagnostics-bastion.primary_blob_endpoint
  }
}

resource "random_string" "suffix-bastion" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa-boot-diagnostics-bastion" {
  name                            = "triangle${random_string.suffix-bastion.result}"
  resource_group_name             = var.lab-rg
  location                        = var.vhub-1-region
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  allow_nested_items_to_be_public = true
  public_network_access_enabled   = true

  blob_properties {
    versioning_enabled = false
  }
}