data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                = var.container_app_env_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = var.container_app_name
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"

  registry {
    server               = azurerm_container_registry.main.login_server
    identity             = "System"
  }

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = var.container_app_name
      image  = "${azurerm_container_registry.main.login_server}/${var.container_app_name}:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# ACR Pull ロールを Container App のマネージド ID に付与
resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.main.identity[0].principal_id
}

# GitHub Actions 用 Azure AD アプリ
resource "azuread_application" "github_actions" {
  display_name = "github-megaro-keitaiso"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

# OIDC フェデレーション（main ブランチ）
resource "azuread_application_federated_identity_credential" "github_main" {
  application_id = azuread_application.github_actions.id
  display_name   = "github-main"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repo}:ref:refs/heads/main"
  audiences      = ["api://AzureADTokenExchange"]
}

# GitHub Actions に Contributor ロール付与（リソースグループスコープ）
resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_actions.object_id
}

# GitHub Actions に AcrPush ロール付与
resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github_actions.object_id
}
