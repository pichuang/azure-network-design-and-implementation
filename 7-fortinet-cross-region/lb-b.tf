# https://github.com/Azure/terraform-azurerm-avm-res-network-loadbalancer/tree/v0.2.2?tab=readme-ov-file#input_backend_address_pool_configuration
module "elb-b" {
  source           = "Azure/avm-res-network-loadbalancer/azurerm"
  version          = "0.2.2"
  enable_telemetry = var.enable_telemetry

  name                        = "elb-b"
  location                    = var.region-b
  resource_group_name         = module.rg-b.name
  frontend_subnet_resource_id = module.vnet-fgt-b.subnets["snet-external"].resource_id

  frontend_ip_configurations = {
    external = {
      name                                   = "elb-b-frontend"
      frontend_private_ip_address_allocation = "Static"
      frontend_private_ip_address            = "172.26.0.10"
      zones                                  = [1, 2, 3]
    }
  }
  backend_address_pools = {
    bepool1 = {
      name = "bepool-1"
      # virtual_network_resource_id = azurerm_virtual_network.vnet-fgt-b.id
    }
  }

  backend_address_pool_addresses = {
    backend1 = {
      name                             = "backend1"
      ip_address                       = "172.26.0.4"
      backend_address_pool_object_name = "bepool1"
      virtual_network_resource_id      = module.vnet-fgt-b.resource_id
    }
  }

  lb_probes = {
    tcp8008 = {
      name                = "tcp8008"
      protocol            = "Tcp"
      port                = 8008
      interval_in_seconds = 5
      number_of_probes    = 2
    }
  }

  lb_rules = {
    rule_forward_all = {
      name                              = "rule_forward_all"
      protocol                          = "All"
      frontend_port                     = 0
      backend_port                      = 0
      frontend_ip_configuration_name    = "elb-b-frontend"
      backend_address_pool_object_names = ["bepool1"]
      probe_object_name                 = "tcp8008"
      idle_timeout_in_minutes           = 4
      load_distribution                 = "SourceIPProtocol"
      disable_outbound_snat             = true
      enable_tcp_reset                  = false
      enable_floating_ip                = true
    }
  }

  depends_on = [
    module.vnet-fgt-b,
    module.vnet-fgt-b["snet-external"]
  ]
}


# https://github.com/Azure/terraform-azurerm-avm-res-network-loadbalancer/tree/v0.2.2?tab=readme-ov-file#input_backend_address_pool_configuration
module "ilb-b" {
  source           = "Azure/avm-res-network-loadbalancer/azurerm"
  version          = "0.2.2"
  enable_telemetry = var.enable_telemetry

  name                        = "ilb-b"
  location                    = var.region-b
  resource_group_name         = module.rg-b.name
  frontend_subnet_resource_id = module.vnet-fgt-b.subnets["snet-internal"].resource_id

  frontend_ip_configurations = {
    internal = {
      name                                   = "ilb-b-frontend"
      frontend_private_ip_address_allocation = "Static"
      frontend_private_ip_address            = "172.26.0.100"
      zones                                  = [1, 2, 3]
    }
  }
  backend_address_pools = {
    pool1 = {
      name = "ilb-b-backend"
    }
  }

  backend_address_pool_addresses = {
    backend1 = {
      name                             = "backend1"
      ip_address                       = "172.26.0.68"
      backend_address_pool_object_name = "pool1"
      virtual_network_resource_id      = module.vnet-fgt-b.resource_id
    }
  }

  lb_probes = {
    tcp8008 = {
      name                = "tcp8008"
      protocol            = "Tcp"
      port                = 8008
      interval_in_seconds = 5
      number_of_probes    = 2
    }
  }

  lb_rules = {
    rule_forward_all = {
      name                              = "rule_forward_all"
      protocol                          = "All"
      frontend_port                     = 0
      backend_port                      = 0
      frontend_ip_configuration_name    = "ilb-b-frontend"
      backend_address_pool_object_names = ["pool1"]
      probe_object_name                 = "tcp8008"
      idle_timeout_in_minutes           = 4
      load_distribution                 = "SourceIPProtocol"
      disable_outbound_snat             = true
      enable_tcp_reset                  = false
      enable_floating_ip                = true
    }
  }

  depends_on = [
    module.vnet-fgt-b,
    module.vnet-fgt-b["snet-internal"]
  ]
}