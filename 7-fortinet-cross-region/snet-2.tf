module "snet-2" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.5.0"

  name = "snet-2"
  virtual_network = {
    resource_id = module.vnet-fgt-a.resource_id
  }

  route_table = {
    id = module.rt-2.resource_id
  }

  address_prefixes = ["172.16.2.0/24"]
}

module "rt-2" {
  source                        = "Azure/avm-res-network-routetable/azurerm"
  version                       = "0.2.2"
  location                      = var.region-a
  resource_group_name           = module.rg-a.name
  name                          = "rt-2"
  disable_bgp_route_propagation = true

  routes = {
    default-route = {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.16.0.100"
    }

    rt-to-1 = {
      name                   = "rt-to-1"
      address_prefix         = "192.168.1.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.16.0.100"
    }
  }

  subnet_resource_ids = {
    snet-2 = module.snet-2.resource_id
  }

  depends_on = [
    module.rg-a,
  ]
}


module "vm-2" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.1"

  enable_telemetry                   = var.enable_telemetry
  location                           = var.region-a
  resource_group_name                = module.rg-a.name
  sku_size                           = "Standard_B1ms"
  os_type                            = "Linux"
  name                               = "vm-2"
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
      name                         = "nic-2"
      acceleration_network_enabled = false
      ip_forwarding_enabled        = false
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.snet-2.resource_id
        }
      }
    }
  }

  depends_on = [
    module.rg-a,
    module.vnet-fgt-a,
  ]
}