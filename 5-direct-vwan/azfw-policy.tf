
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy

resource "azurerm_firewall_policy" "azfw-policy" {
  name                = "triangle-azfw-policy"
  resource_group_name = var.lab-rg
  location            = var.lab-location
  sku                 = "Standard"

  threat_intelligence_mode = "Alert"

  # IDPS is available only for premium policies
  # intrusion_detection {
  #   mode = "Alert"
  # }

  base_policy_id = null

  dns {
    servers       = null
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "azfw-rcg" {
  name               = "azfw-rcg"
  firewall_policy_id = azurerm_firewall_policy.azfw-policy.id
  priority           = 500
    application_rule_collection {
      name     = "app_rule_collection1"
      priority = 500
      action   = "Deny"
      rule {
        name = "arc-allow-ifconfig"
        protocols {
          type = "Http"
          port = 80
        }
        protocols {
          type = "Https"
          port = 443
        }
        source_addresses  = ["*"]
        destination_fqdns = ["ifconfig.me"]
      }
    }

  network_rule_collection {
    name     = "nrc-allow-rules"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "allowanyany"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "nrc-deny-rules"
    priority = 100
    action   = "Deny"
    rule {
      name                  = "deny-google"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
      destination_addresses = ["8.8.8.8"]
      destination_ports     = ["*"]
    }

    rule {
      name                  = "deny-to-az-se"
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
      source_addresses      = ["*"]
      destination_addresses = ["10.2.5.9"]
      destination_ports     = ["*"]
    }

  }
}