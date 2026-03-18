terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "megaro-web-rg"
    storage_account_name = "megarotfstate"
    container_name       = "tfstate"
    key                  = "megaro-keitaiso.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}
