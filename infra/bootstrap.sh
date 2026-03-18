#!/bin/bash
# Terraform の state を保存する Storage Account を作成するスクリプト
# terraform init より前に一度だけ実行する

set -e

RESOURCE_GROUP="megaro-web-rg"
LOCATION="eastasia"
STORAGE_ACCOUNT="megarotfstate"
CONTAINER="tfstate"

az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --min-tls-version TLS1_2

az storage container create \
  --name $CONTAINER \
  --account-name $STORAGE_ACCOUNT

echo "Bootstrap complete."
echo "Storage Account: $STORAGE_ACCOUNT"
echo "Container: $CONTAINER"
