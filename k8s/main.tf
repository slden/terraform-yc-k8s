# Создаем VPC-сеть
resource "yandex_vpc_network" "vpc" {
    name = "my-vpc-network"
    description = "VPC network for the K8s cluster"
}

# Описание Security group
resource "yandex_vpc_security_group" "sg1" {
  name        = "sg1"
  description = "Security group for vpc network resources"
  network_id  = yandex_vpc_network.vpc.id

  labels = {
    environment = "dev"
    project = "k8s-cluster-demo"
  }

  # Разрешаем входящий трафик на 8080 из Интернета
  ingress {
    protocol       = "TCP"
    description    = "Allow incoming TCP traffic on port 8080 from Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }

  # Разрешаем весь трафик внутри кластера (по всей подсети)
  ingress {
    protocol       = "ANY"
    description    = "Allow all traffic inside the cluster network"
    v4_cidr_blocks = [var.subnet_cidr]
  }  

  # Разрешаем весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing traffic"
    v4_cidr_blocks = [var.subnet_cidr]
  }
}

# Создаем subnet
resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.subnet_cidr]
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
      zone = yandex_vpc_subnet.subnet.zone
      subnet_id = yandex_vpc_subnet.subnet.id
    }
  }

    # Линтер ругается 'Unexpected attribute: An attribute named "public_ip" is not expected here'
    # Но в свежей документации провайдера указано как раз такая конструкция 
    public_ip = true

    # Снова ругается линтер
    security_group_ids = ["${yandex_vpc_security_group.security_group_name.id}"]


    

  # Т.к не прод, используем один аккаунт (с ролью admin)  
  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
}
