variable "resource_group_name" {
    type = string
    description = "Nome do resource group"  
}

variable "location" {
    type = string
    description = "Localização dos recursos"
    default = "East US"
}

variable "cluster_name" {
    type = string
    description = "Nome do cluster AKS"
}

variable "acr_name" {
    type = string
    default = "acrlabcicdv32026"  
}

variable "key_vault_name" {
    type = string
    description = "Nome do Azure Key Vault"
}