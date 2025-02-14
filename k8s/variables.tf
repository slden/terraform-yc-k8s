variable "folder_id" {
    type = string
    sensitive = true
}

variable "cloud_id" {
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

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type = string
}

variable "cluster_name" {
  description = "Name of K8s-cluster"
}

variable "network_id" {
  type = string
}

variable "master_version" {
  description = "K8s version for master"
  type = string
}

variable "service_account_id" {
  type = string
}



