
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
#   application_rule_collection {
#     name     = "app_rule_collection1"
#     priority = 500
#     action   = "Deny"
#     rule {
#       name = "app_rule_collection1_rule1"
#       protocols {
#         type = "Http"
#         port = 80
#       }
#       protocols {
#         type = "Https"
#         port = 443
#       }
#       source_addresses  = ["10.0.0.1"]
#       destination_fqdns = ["*.microsoft.com"]
#     }
#   }

  network_rule_collection {
    name     = "nrc-anytoany"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "allowanyany"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}