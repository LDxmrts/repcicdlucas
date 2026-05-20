variable "resource_group_name" {
    type = string
    description = "Nome do Resource Group onde os recursos serão criados"
    default = "rg-lab-cicd"
}

variable "location" {
    type = string
    description = "Região da Azure para implantação dos recursos"
    default = "East US"
}

variable "acr_name" {
    type = string
    description = "Nome do Azure Container Registry (Deve ser globalmente único, apenas letras e números"
    default = "acrlabcicdactions2026"
}

variable "cluster_name" {
    type = string
    description = "Nome do cluster"
    default = "aks-lab-cicd"
}

variable "node_count" {
    type = number
    description = "Quantidade de nodes"
    default = 1
}

variable "vm_size" {
    type = string
    description = "Categoria da VM"
    default = "Standard_D2s_V3"
}

variable "dns_prefix" {
  type        = string
  description = "Prefixo de DNS para o cluster AKS"
  default     = "akslab"
}