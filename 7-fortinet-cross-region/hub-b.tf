module "vnet-fgt-b" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.2"
  name                = "vnet-fgt-b"
  enable_telemetry    = false
  resource_group_name = module.rg-b.name
  location            = var.region-b

  address_space = ["172.26.0.0/22"]

  subnets = {
    snet-external = {
      name             = "snet-external"
      address_prefixes = ["172.26.0.0/26"]
      route_table = {
        id = module.rt-fgt-external-b.resource_id
      }
    }

    snet-internal = {
      name             = "snet-internal"
      address_prefixes = ["172.26.0.64/26"]
      route_table = {
        id = module.rt-fgt-internal-b.resource_id
      }
    }

    snet-ars-b = {
      name             = "RouteServerSubnet"
      address_prefixes = ["172.26.1.0/27"]
    }

    snet-bastion-b = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["172.26.1.32/27"]
    }
  }
}

module "rt-fgt-external-b" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.region-b
  resource_group_name = module.rg-b.name
  name                = "rt-fgt-external-b"

  disable_bgp_route_propagation = true

  routes = {
    default-route = {
      name           = "default-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }

  subnet_resource_ids = {
    subnet1 = module.vnet-fgt-b.subnets["snet-external"].resource_id
  }

  depends_on = [
    module.rg-b,
  ]
}

module "rt-fgt-internal-b" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.region-b
  resource_group_name = module.rg-b.name
  name                = "rt-fgt-internal-b"

  disable_bgp_route_propagation = true

  subnet_resource_ids = {
    subnet-internal-b = module.vnet-fgt-b.subnets["snet-internal"].resource_id
  }

  depends_on = [
    module.rg-b,
  ]
}