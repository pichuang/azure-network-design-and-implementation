# https://github.com/Azure/terraform-azurerm-avm-res-network-publicipaddress/tree/v0.1.2

module "pip-ars-a" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.2"

  enable_telemetry        = var.enable_telemetry
  resource_group_name     = module.rg-a.name
  name                    = "pip-ars-a"
  location                = var.region-a
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = [1, 2, 3]
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  sku_tier                = "Regional"
  ddos_protection_mode    = "Disabled"
}

resource "azurerm_route_server" "ars-a" {
  name                             = "ars-a"
  resource_group_name              = module.rg-a.name
  location                         = var.region-a
  sku                              = "Standard"
  public_ip_address_id             = module.pip-ars-a.public_ip_id
  subnet_id                        = module.vnet-fgt-a.subnets["snet-ars-a"].resource_id
  branch_to_branch_traffic_enabled = true

  depends_on = [
    module.pip-ars-a,
    module.vnet-fgt-a
  ]
}

resource "azurerm_route_server_bgp_connection" "rs-bgp-conn-a" {
  name            = "fortinet-a"
  route_server_id = azurerm_route_server.ars-a.id
  peer_asn        = 65250
  peer_ip         = "172.16.0.68"

  depends_on = [ azurerm_route_server.ars-a ]
}
