module "vnet-fgt-a" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.2"
  name                = "vnet-fgt-a"
  enable_telemetry    = true
  resource_group_name = module.rg-a.name
  location            = var.region-a

  address_space = ["172.16.0.0/22"]

  subnets = {
    snet-external = {
      name             = "snet-external"
      address_prefixes = ["172.16.0.0/26"]
      route_table = {
        id = module.rt-fgt-external-a.resource_id
      }
    }

    snet-internal = {
      name             = "snet-internal"
      address_prefixes = ["172.16.0.64/26"]
      route_table = {
        id = module.rt-fgt-internal-a.resource_id
      }
    }

    snet-ars-a = {
      name             = "RouteServerSubnet"
      address_prefixes = ["172.16.1.0/27"]
    }

    snet-bastion-a = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["172.16.1.32/27"]
    }
  }
}

module "rt-fgt-external-a" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.region-a
  resource_group_name = module.rg-a.name
  name                = "rt-fgt-external-a"

  disable_bgp_route_propagation = true

  routes = {
    default-route = {
      name           = "default-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }

  subnet_resource_ids = {
    subnet1 = module.vnet-fgt-a.subnets["snet-external"].resource_id
  }

  depends_on = [
    module.rg-a,
  ]
}

module "rt-fgt-internal-a" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.2.2"
  location            = var.region-a
  resource_group_name = module.rg-a.name
  name                = "rt-fgt-internal-a"

  disable_bgp_route_propagation = true

  subnet_resource_ids = {
    subnet-internal-a = module.vnet-fgt-a.subnets["snet-internal"].resource_id
  }

  depends_on = [
    module.rg-a,
  ]
}