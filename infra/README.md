# Terraform 運用手順

## 構成概要

| リソース | 名前 |
|---|---|
| Resource Group | `megaro-web-rg` |
| Azure Container Registry | `megarokeitaiso` |
| Container Apps Environment | `megaro-env` |
| Container App | `megaro-keitaiso` |
| Terraform State Storage | `megarotfstate` (Blob Container: `tfstate`) |

---

## 前提条件

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.7
- [Azure CLI](https://learn.microsoft.com/ja-jp/cli/azure/install-azure-cli)
- Azure サブスクリプションへのアクセス権（Contributor 以上）

---

## 初回セットアップ（一度だけ実行）

### 1. Azure ログイン

```bash
az login
az account set --subscription <SUBSCRIPTION_ID>
```

### 2. Terraform State 用 Storage Account の作成

`terraform init` より**前に**一度だけ実行する。

```bash
cd infra
bash bootstrap.sh
```

このスクリプトは以下を作成します：

- Storage Account: `megarotfstate`
- Blob Container: `tfstate`

### 3. Terraform 初期化

```bash
terraform init
```

Azure Blob Backend に接続し、プロバイダーをダウンロードします。

---

## 通常の運用フロー

### plan（変更内容の確認）

```bash
cd infra
terraform plan
```

追加・変更・削除されるリソースが表示されます。必ず apply 前に確認してください。

### apply（リソースの作成・更新）

```bash
terraform apply
```

確認プロンプトが表示されるので `yes` と入力すると実行されます。

自動承認する場合（CI 等）：

```bash
terraform apply -auto-approve
```

### destroy（リソースの削除）

> **注意**: 本番環境では慎重に実行してください。

```bash
terraform destroy
```

---

## apply 後の作業（初回のみ）

### GitHub Secrets の設定

`terraform apply` 完了後、以下のコマンドで出力値を確認します：

```bash
terraform output
```

出力された値を GitHub リポジトリの Secrets に設定します：

| Secret 名 | 値 |
|---|---|
| `AZURE_CLIENT_ID` | `github_actions_client_id` の出力値 |
| `AZURE_TENANT_ID` | `tenant_id` の出力値 |
| `AZURE_SUBSCRIPTION_ID` | `subscription_id` の出力値 |
| `ACR_LOGIN_SERVER` | `acr_login_server` の出力値 |
| `ACR_NAME` | `megarokeitaiso` |
| `CONTAINER_APP_NAME` | `megaro-keitaiso` |
| `RESOURCE_GROUP` | `megaro-web-rg` |

設定場所: GitHub リポジトリ > Settings > Secrets and variables > Actions

---

## ファイル構成

```
infra/
├── providers.tf    # Terraform バージョン・プロバイダー・Backend 設定
├── variables.tf    # 変数定義（リージョン・リソース名など）
├── main.tf         # リソース定義
├── outputs.tf      # 出力値（GitHub Secrets 設定に使用）
└── bootstrap.sh    # State 用 Storage Account 作成スクリプト（初回のみ）
```

---

## よく使うコマンド

```bash
# 特定リソースだけ plan
terraform plan -target=azurerm_container_app.main

# 特定リソースだけ apply
terraform apply -target=azurerm_container_app.main

# State の確認
terraform state list

# 特定リソースの State 詳細
terraform state show azurerm_container_app.main

# フォーマット整形
terraform fmt

# 設定ファイルの検証
terraform validate
```
