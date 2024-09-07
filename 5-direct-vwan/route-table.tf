# resource "azurerm_route_table" "rt-vnet-1" {
#   name                = "rt-${azurerm_virtual_network.vnet-1.name}"
#   location            = azurerm_virtual_network.vnet-1.location
#   resource_group_name = var.lab-rg
#   bgp_route_propagation_enabled = true

#   route {
#     name           = "route-to-azfw"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "VirtualAppliance"
#     next_hop_in_ip_address  = azurerm_firewall.azfw-1.ip_configuration_ids[0]
#   }

#   route {
#     name           = "route-to-homecloud"
#     address_prefix = "122.116.34.187/32"
#     next_hop_type  = "Internet"
#   }

# }

# resource "azurerm_route_table" "rt-vnet-2" {
#   name                = "rt-${azurerm_virtual_network.vnet-2.name}"
#   location            = azurerm_virtual_network.vnet-2.location
#   resource_group_name = var.lab-rg
#   bgp_route_propagation_enabled = true

#   route {
#     name           = "route-to-azfw"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "VirtualAppliance"
#     next_hop_in_ip_address  = azurerm_firewall.azfw-2.ip_configuration_ids[0]
#   }

#   route {
#     name           = "route-to-homecloud"
#     address_prefix = "122.116.34.187/32"
#     next_hop_type  = "Internet"
#   }

# }