resource "azurerm_firewall" "azfw-1" {
  name                = "azfw-${var.vhub-1-region}"
  location            = azurerm_virtual_hub.vhub-1.location
  resource_group_name = var.lab-rg
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub-1.id
    public_ip_count = 1
  }

  firewall_policy_id = azurerm_firewall_policy.azfw-policy.id
}

resource "azurerm_firewall" "azfw-2" {
  name                = "azfw-${var.vhub-2-region}"
  location            = azurerm_virtual_hub.vhub-2.location
  resource_group_name = var.lab-rg
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub-2.id
    public_ip_count = 1
  }

  firewall_policy_id = azurerm_firewall_policy.azfw-policy.id
}