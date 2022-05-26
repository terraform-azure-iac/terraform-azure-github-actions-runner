terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
         resource_group_name  = "terraformbackend"
         storage_account_name = "terraformbackendxxyygg"
         container_name       = "terraformbackend"
         key                  = "github-actions.tfstate"
     }
}

provider "azurerm" {
  features {}

  subscription_id   = "" 
}