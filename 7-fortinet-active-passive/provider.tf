terraform {
  required_version = "~> v1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.115.0"
    }
    random = {
      version = "~> 3.6.2"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

resource "azurerm_resource_group" "resource-group" {
  location = var.lab-location
  name     = var.lab-rg
}
