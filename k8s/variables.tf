variable "folder_id" {
    description = "id каталога в YC"
    type = string
    sensitive = true
}

variable "cloud_id" {
  description = "id облака"
  type = string
  sensitive = true
}

# yc init
# yc iam create-token
variable "yandex_token" {
  description = "IAM token"
  type = string
  sensitive = true
}