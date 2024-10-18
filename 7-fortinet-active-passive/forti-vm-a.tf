resource "azurerm_public_ip" "public-ip-vnet-1" {
  name                = "public-ip-${var.vhub-1-region}"
  location            = var.vhub-1-region
  resource_group_name = var.lab-rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# Create network interface card
resource "azurerm_network_interface" "nic-vnet-a1" {
  name                           = "nic-fortinet-a1"
  location                       = var.vhub-1-region
  resource_group_name            = var.lab-rg
  accelerated_networking_enabled = false # VMSizeIsNotPermittedToEnableAcceleratedNetworking
  ip_forwarding_enabled          = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-fortinet-wan.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.255.248.116"
    public_ip_address_id          = azurerm_public_ip.public-ip-vnet-1.id

  }
}

resource "azurerm_network_interface" "nic-vnet-a2" {
  name                           = "nic-fortinet-a2"
  location                       = var.vhub-1-region
  resource_group_name            = var.lab-rg
  accelerated_networking_enabled = false # VMSizeIsNotPermittedToEnableAcceleratedNetworking
  ip_forwarding_enabled          = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-fortinet-lan.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.255.248.132"
  }
}

resource "azurerm_linux_virtual_machine" "vm-foritnet-a" {
  name                  = "vm-foritnet-a"
  location              = var.vhub-1-region
  resource_group_name   = var.lab-rg
  network_interface_ids = [azurerm_network_interface.nic-vnet-a1.id, azurerm_network_interface.nic-vnet-a2.id]
  size                  = "Standard_B1ms"
  zone                  = 2

  os_disk {
    name                 = "disk-fortinet-a"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    write_accelerator_enabled = false
  }

  source_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm" # fortinet_fg-vm, fortinet_fg-vm_payg_2023
    version   = "latest"
  }

  plan {
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
    name      = "fortinet_fg-vm"
  }

  computer_name                   = "vm-foritnet-a"
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username = var.admin_username

    public_key = file("../repairman_rsa.pub")
  }

  custom_data = filebase64("cloud-init-a.txt")

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sa-boot-diagnostics-1.primary_blob_endpoint
  }
}

resource "random_string" "suffix-1" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa-boot-diagnostics-1" {
  name                            = "triangle${random_string.suffix-1.result}"
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