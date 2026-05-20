terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.9"
    }
  }
  backend "azurerm" {
    key = "terraform2.tfstate"
  }
}

provider "azurerm" {
    features {
      key_vault {
        purge_soft_delete_on_destroy = true
        recover_soft_deleted_certificates = true
      }
    }
  
}