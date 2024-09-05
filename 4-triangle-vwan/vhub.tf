#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub

resource "azurerm_virtual_hub" "vhub-1" {
  name                   = "vhub-${var.vhub-1-region}"
  resource_group_name    = var.lab-rg
  location               = var.vhub-1-region
  virtual_wan_id         = azurerm_virtual_wan.vwan-triangle.id
  address_prefix         = "10.11.0.0/24"
  hub_routing_preference = "ASPath"
  sku                    = "Standard"
}

resource "azurerm_virtual_hub" "vhub-2" {
  name                   = "vhub-${var.vhub-2-region}"
  resource_group_name    = var.lab-rg
  location               = var.vhub-2-region
  virtual_wan_id         = azurerm_virtual_wan.vwan-triangle.id
  address_prefix         = "10.22.0.0/24"
  hub_routing_preference = "ASPath"
  sku                    = "Standard"
}

resource "azurerm_virtual_hub" "vhub-3" {
  name                   = "vhub-${var.vhub-3-region}"
  resource_group_name    = var.lab-rg
  location               = var.vhub-3-region
  virtual_wan_id         = azurerm_virtual_wan.vwan-triangle.id
  address_prefix         = "10.33.0.0/24"
  hub_routing_preference = "ASPath"
  sku                    = "Standard"
}
