module "vnet-1" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.2"

  address_space       = ["192.168.1.0/24"]
  resource_group_name = module.rg-a.name
  location            = var.region-a
  name                = "vnet-1"

  subnets = {
    snet-1 = {
      name             = "snet-1"
      address_prefixes = ["192.168.1.0/25"]
      route_table = {
        id = module.rt-1.resource_id
      }
    }
  }
}

module "vm-1" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.1"

  enable_telemetry                   = var.enable_telemetry
  location                           = var.region-a
  resource_group_name                = module.rg-a.name
  sku_size                           = "Standard_B1ms"
  os_type                            = "Linux"
  name                               = "vm-1"
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
      name                         = "nic-1"
      acceleration_network_enabled = false
      ip_forwarding_enabled        = false
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.vnet-1.subnets["snet-1"].resource_id
        }
      }
    }
  }

  depends_on = [
    module.rg-a,
    module.vnet-1,
  ]
}

module "rt-1" {
  source                        = "Azure/avm-res-network-routetable/azurerm"
  version                       = "0.2.2"
  location                      = var.region-a
  resource_group_name           = module.rg-a.name
  name                          = "rt-1"
  disable_bgp_route_propagation = false

  routes = {
    default-route = {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.16.0.100"
    }
    rt-to-2 = {
      name                   = "rt-to-2"
      address_prefix         = "172.16.2.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "172.16.0.100"
    }
  }

  subnet_resource_ids = {
    subnet1 = module.vnet-1.subnets["snet-1"].resource_id
  }

  depends_on = [
    module.rg-a,
  ]
}


module "peering-1-to-a" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "0.4.2"

  virtual_network = {
    resource_id = module.vnet-1.resource_id
  }

  remote_virtual_network = {
    resource_id = module.vnet-fgt-a.resource_id
  }

  name                         = "peering-1-to-a"
  # Allow 'vnet-1' to access 'vnet-fgt-a'
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true

  create_reverse_peering               = true
  reverse_name                         = "peering-a-to-1"
  reverse_allow_virtual_network_access = true
  reverse_allow_forwarded_traffic      = true
  reverse_allow_gateway_transit        = true
  reverse_use_remote_gateways          = false

  depends_on = [
    module.rg-a,
    module.vnet-1,
    azurerm_route_server.ars-a
  ]
}
