# Создаем VPC-сеть
resource "yandex_vpc_network" "vpc" {
    name = "my-vpc-network"
    description = "VPC network for the K8s cluster"
}

# Создаем subnet
resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = ["var.subnet_cidr"]
  zone = "ru-central1-d"
  network_id = yandex_vpc_network.vpc.id
}

# Описание k8s кластера
resource "yandex_kubernetes_cluster" "zonal_cluster" {
  name        = var.cluster_name
  description = "Managed Kubernetes zonal Cluster"

  network_id = yandex_vpc_network.vpc.id
      
  master {
    version = var.master_version
    zonal {
        
    }
  }

  # Т.к не прод, используем один аккаунт (с ролью admin)  
  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
}
