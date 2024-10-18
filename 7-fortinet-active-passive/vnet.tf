# https://blog.pichuang.com.tw/azure-subnets.html

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.255.248.0/24", "10.255.249.0/24"]
  location            = var.vhub-1-region
  name                = "AZSG-WAN-VNet"
  resource_group_name = var.lab-rg

  depends_on = [
    azurerm_resource_group.resource-group
  ]
}

resource "azurerm_subnet" "azurefirewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.248.192/26"]

}

resource "azurerm_subnet" "azurefirewallmanagementsubnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.249.192/26"]

}

resource "azurerm_subnet" "routeserversubnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.248.32/27"]

}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.248.0/27"]

}

resource "azurerm_subnet" "subnet-fortinet-wan" {
  name                 = "subnet-fortinet-wan"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.248.112/28"]

}

resource "azurerm_subnet" "subnet-fortinet-lan" {
  name                 = "subnet-fortinet-lan"
  resource_group_name  = var.lab-rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.255.248.128/28"]

}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg-vnet-1" {
  name                = "nsg-vnet-${var.vhub-1-region}"
  location            = var.vhub-1-region
  resource_group_name = var.lab-rg

  security_rule {
    name                       = "Allow-inbound-any"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-outbound-any"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "link-nsg-wan" {
  subnet_id                 = azurerm_subnet.subnet-fortinet-wan.id
  network_security_group_id = azurerm_network_security_group.nsg-vnet-1.id
}

resource "azurerm_subnet_network_security_group_association" "link-nsg-lan" {
  subnet_id                 = azurerm_subnet.subnet-fortinet-lan.id
  network_security_group_id = azurerm_network_security_group.nsg-vnet-1.id
}