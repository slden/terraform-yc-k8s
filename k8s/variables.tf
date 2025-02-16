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
#  Закомментим чтобы можно было передать значение в output - но вообще так не стоит делать   
#  sensitive = true
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type = string
}

variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "node_memory" {
  type = number
  default = 2
}

variable "node_cores" {
  type = number
  default = 2
}

variable "node_disk_size" {
  description = "Disk size (in GB)"
  type = number
  default = 64
}

variable "min_nodes" {
  description = "Minimum number of k8s-nodes in a group"
  type = number
  default = 1
}

variable "max_nodes" {
  description = "Maximum number of k8s-nodes in a group"
  type = number
  default = 2
}

variable "initial_nodes" {
  description = "The initial number of k8s-nodes in a group"
  type = number
  default = 1
}