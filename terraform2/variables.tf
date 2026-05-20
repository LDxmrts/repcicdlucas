variable "resource_group_name" {
    type = string
    default = "rg-lab-cicd-v2"
}

variable "location" {
    type = string
    default = "East US"
}

variable "cluster_name" {
    type = string
    default = "aks-lab-cicd-v2"
}

variable "acr_name" {
    type = string
    default = "acrlabcicdv22026"
}

variable "key_vault_name" {
    type = string
    default = "kv-lab-cicd-v2-2026"
}