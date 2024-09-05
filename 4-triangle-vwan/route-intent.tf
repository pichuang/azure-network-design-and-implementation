resource "azurerm_virtual_hub_routing_intent" "routingintent-vhub-1" {
  name           = "routingintent-to-internet"
  virtual_hub_id = azurerm_virtual_hub.vhub-1.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.azfw-1.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.azfw-1.id
  }
}

resource "azurerm_virtual_hub_routing_intent" "routingintent-vhub-2" {
  name           = "routingintent-to-internet"
  virtual_hub_id = azurerm_virtual_hub.vhub-2.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.azfw-2.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.azfw-2.id
  }
}

resource "azurerm_virtual_hub_routing_intent" "routingintent-vhub-3" {
  name           = "routingintent-to-internet"
  virtual_hub_id = azurerm_virtual_hub.vhub-3.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.azfw-3.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.azfw-3.id
  }
}