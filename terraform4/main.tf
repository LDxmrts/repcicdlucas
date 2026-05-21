# 6. Provisionamento da Rede Padronizada
resource "azurerm_virtual_network" "lz_vnet" {
  name                = "vnet-landingzone-dev"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.lz_rg.location
  resource_group_name = azurerm_resource_group.lz_rg.name

  subnet {
    name             = "snet-applications"
    address_prefixes = ["10.10.1.0/24"]
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

  sku_name = "standard"

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