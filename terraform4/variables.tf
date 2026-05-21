variable "resource_group_name" {
  type        = string
  description = "Nome do Resource Group da Landing Zone"
}

variable "location" {
  type        = string
  description = "Região primária do Resource Group e da VNet"
}

variable "environment" {
  type        = string
  description = "Tag de ambiente (ex: Dev, Homolog)"
}

variable "allowed_locations" {
  type        = list(string)
  description = "Lista de regiões permitidas pelas políticas de governança"
}

variable "allowed_vm_skus" {
  type        = list(string)
  description = "Lista de SKUs de máquina virtual permitidas para controle de custo"
}

variable "key_vault_name" {
  type        = string
  description = "Nome globalmente único do Azure Key Vault"
}