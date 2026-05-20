output "acr_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "URL do servidor do Azure Container Registry"
}

output "acr_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "Usuário administrador do Azure Container Registry"
}

output "acr_password" {
  value       = azurerm_container_registry.acr.admin_password
  description = "Senha administradora do Azure Container Registry"
  sensitive   = true # Garante que o Terraform mascare este dado nos logs de texto ordinários
}