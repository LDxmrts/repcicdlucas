terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 5.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "stbackendlz001"
    container_name       = "tfstate"
    key                  = "landingzone.dev.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}