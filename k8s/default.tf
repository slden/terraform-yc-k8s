# terraform-yc-k8s/k8s/default.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.138.0"
    }
  }
}

# Нужны ли locals-переменные ? 

provider "yandex" {
  service_account_key_file = "./authorized_key.json"
  token = var.yandex_token
  cloud_id = var.cloud_id 
  folder_id = var.folder_id
  zone = "ru-central1-d"
}