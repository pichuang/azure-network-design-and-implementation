module "pip-bastion-a" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.2"

  enable_telemetry        = var.enable_telemetry
  resource_group_name     = module.rg-a.name
  name                    = "pip-bastion-a"
  location                = var.region-a
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = [1, 2, 3]
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  sku_tier                = "Regional"
  ddos_protection_mode    = "Disabled"
}

module "azure-bastion" {
  source = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"

  enable_telemetry    = var.enable_telemetry
  name                = "bastion-a"
  resource_group_name = module.rg-a.name
  location            = var.region-a
  copy_paste_enabled  = true
  file_copy_enabled   = false
  sku                 = "Basic"
  
  ip_configuration = {
    name                 = "bastion-ipconfig"
    subnet_id            = module.vnet-fgt-a.subnets["snet-bastion-a"].resource_id
    public_ip_address_id = module.pip-bastion-a.public_ip_id
  }

  ip_connect_enabled     = false
  scale_units            = 2
  shareable_link_enabled = false
  tunneling_enabled      = false
  kerberos_enabled       = false

}
