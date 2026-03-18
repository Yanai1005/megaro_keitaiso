output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "container_app_fqdn" {
  value = azurerm_container_app.main.latest_revision_fqdn
}

output "github_actions_client_id" {
  description = "GitHub Secrets の AZURE_CLIENT_ID に設定"
  value       = azuread_application.github_actions.client_id
}

output "tenant_id" {
  description = "GitHub Secrets の AZURE_TENANT_ID に設定"
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "GitHub Secrets の AZURE_SUBSCRIPTION_ID に設定"
  value       = data.azurerm_client_config.current.subscription_id
}
