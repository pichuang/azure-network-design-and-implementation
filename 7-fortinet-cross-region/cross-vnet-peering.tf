module "peering-cross-vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "0.4.2"

  virtual_network = {
    resource_id = module.vnet-fgt-a.resource_id
  }

  remote_virtual_network = {
    resource_id = module.vnet-fgt-b.resource_id
  }

  name                         = "peering-a-to-b"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  create_reverse_peering               = true
  reverse_name                         = "peering-b-to-a"
  reverse_allow_forwarded_traffic      = true
  reverse_allow_gateway_transit        = true
  reverse_allow_virtual_network_access = false
  reverse_use_remote_gateways          = false

  depends_on = [
    module.vnet-fgt-a,
    module.vnet-fgt-b
  ]
}
