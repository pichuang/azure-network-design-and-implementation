# https://github.com/Azure/terraform-azurerm-avm-res-network-publicipaddress/tree/v0.1.2

module "pip-ars-b" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.2"

  enable_telemetry        = var.enable_telemetry
  resource_group_name     = module.rg-b.name
  name                    = "pip-ars-b"
  location                = var.region-b
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = [1, 2, 3]
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  sku_tier                = "Regional"
  ddos_protection_mode    = "Disabled"
}

resource "azurerm_route_server" "ars-b" {
  name                             = "ars-b"
  resource_group_name              = module.rg-b.name
  location                         = var.region-b
  sku                              = "Standard"
  public_ip_address_id             = module.pip-ars-b.public_ip_id
  subnet_id                        = module.vnet-fgt-b.subnets["snet-ars-b"].resource_id
  branch_to_branch_traffic_enabled = true

  depends_on = [
    module.pip-ars-b,
    module.vnet-fgt-b
  ]
}

resource "azurerm_route_server_bgp_connection" "rs-bgp-conn-b" {
  name            = "fortinet-b"
  route_server_id = azurerm_route_server.ars-b.id
  peer_asn        = 65250
  peer_ip         = "172.26.0.4"

  depends_on = [ azurerm_route_server.ars-b ]
}
