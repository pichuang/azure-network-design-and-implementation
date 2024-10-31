module "snet-4" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.5.0"

  name = "snet-4"
  virtual_network = {
    resource_id = module.vnet-fgt-b.resource_id
  }
  address_prefixes = ["172.26.2.0/24"]
}

module "rt-4" {
  source                        = "Azure/avm-res-network-routetable/azurerm"
  version                       = "0.2.2"
  location                      = var.region-b
  resource_group_name           = module.rg-b.name
  name                          = "rt-4"
  disable_bgp_route_propagation = true

  routes = {
    default-route = {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.26.0.100"
    }

    rt-to-3 = {
      name                   = "rt-to-3"
      address_prefix         = "192.168.3.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.26.0.100"
    }
  }

  subnet_resource_ids = {
    subnet1 = module.snet-4.resource_id
  }

  depends_on = [
    module.rg-b,
  ]
}


module "vm-4" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.1"

  enable_telemetry                   = var.enable_telemetry
  location                           = var.region-b
  resource_group_name                = module.rg-b.name
  sku_size                           = "Standard_B1ms"
  os_type                            = "Linux"
  name                               = "vm-4"
  zone                               = 1
  disable_password_authentication    = false
  generate_admin_password_or_ssh_key = false
  admin_username                     = var.admin_username
  admin_password                     = var.admin_password

  custom_data = base64encode(file("${path.module}/custom-data-vm.txt"))

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interfaces = {
    network_interface_1 = {
      name                         = "nic-4"
      acceleration_network_enabled = false
      ip_forwarding_enabled        = false
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.snet-4.resource_id
        }
      }
    }
  }

  depends_on = [
    module.rg-b,
    module.vnet-fgt-b,
  ]
}