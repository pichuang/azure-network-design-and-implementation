#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan

resource "azurerm_virtual_wan" "vwan-direct" {
  name                           = "vwan-direct"
  resource_group_name            = azurerm_resource_group.resource-group.name
  location                       = azurerm_resource_group.resource-group.location
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
}