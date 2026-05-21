data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "lz_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Ambiente  = var.environment
    ManagedBy = "Terraform"
  }
}

resource "azurerm_policy_definition" "vm_sku_restriction" {
  name         = "policy-restringir-sku-vm"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "LZ - Restringir SKUs de VM para Custo"
  description  = "Garante que apenas VMs de baixo custo sejam criadas neste escopo."

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          not = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            in    = var.allowed_vm_skus
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "assign_vm_sku" {
  name                 = "asg-policy-sku-vm"
  resource_group_id    = azurerm_resource_group.lz_rg.id
  policy_definition_id = azurerm_policy_definition.vm_sku_restriction.id
  display_name         = "Bloqueio de SKUs caras de VM"
}


resource "azurerm_resource_group_policy_assignment" "assign_allowed_locations" {
  name                 = "asg-policy-locations"
  resource_group_id    = azurerm_resource_group.lz_rg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  display_name         = "Restrição de Regiões de Recursos"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}


resource "azurerm_virtual_network" "lz_vnet" {
  name                = "vnet-landingzone-dev"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name

  subnet {
    name              = "snet-applications"
    address_prefixes  = ["10.10.1.0/24"]
    service_endpoints = ["Microsoft.KeyVault"]
  }

  subnet {
    name             = "snet-database"
    address_prefixes = ["10.10.2.0/24"]
  }

  depends_on = [
    azurerm_resource_group_policy_assignment.assign_vm_sku,
    azurerm_resource_group_policy_assignment.assign_allowed_locations
  ]
}


resource "azurerm_key_vault" "lz_kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.lz_rg.location
  resource_group_name         = azurerm_resource_group.lz_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    
    virtual_network_subnet_ids = [
      azurerm_virtual_network.lz_vnet.subnet.*.id[0]
    ]
  }

  tags = {
    Ambiente  = var.environment
    ManagedBy = "Terraform"
  }
}


resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.lz_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}