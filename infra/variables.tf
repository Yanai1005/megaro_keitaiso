variable "location" {
  type    = string
  default = "eastasia"
}

variable "resource_group_name" {
  type    = string
  default = "megaro-web-rg"
}

variable "acr_name" {
  type    = string
  default = "megarokeitaiso"
}

variable "container_app_name" {
  type    = string
  default = "megaro-keitaiso"
}

variable "container_app_env_name" {
  type    = string
  default = "megaro-env"
}

variable "github_repo" {
  type    = string
  default = "Yanai1005/megaro_keitaiso"
}
