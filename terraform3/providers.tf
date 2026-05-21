terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"
    }
  }
  backend "azurerm" {
    key = "terraform3.tfstate"
    
  }
}

provider "azurerm" {
    features {}
}