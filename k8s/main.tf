# Создаем VPC-сеть
resource "yandex_vpc_network" "vpc" {
  name        = "my-vpc-network"
  description = "VPC network for the K8s cluster"
}

# Описание Security group
resource "yandex_vpc_security_group" "sg1" {
  name        = "sg1"
  description = "Security group for vpc network resources"
  network_id  = yandex_vpc_network.vpc.id

  labels = {
    environment = "dev"
    project     = "k8s-cluster-demo"
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

# KMS ключ для шифрования данных Kubernetes
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "k8s-symetric-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}


# Создаем subnet
resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.subnet_cidr]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vpc.id
}

# Лог-группа для k8s
resource "yandex_logging_group" "k8s_logs" {
  name        = "k8s_logs"
  description = "Log group for Kubernetes master logs"
  folder_id   = var.folder_id
}

# Описание k8s кластера
resource "yandex_kubernetes_cluster" "zonal_cluster" {
  name        = var.cluster_name
  description = "Managed Kubernetes zonal Cluster"

  network_id = yandex_vpc_network.vpc.id

  master {
    version = var.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.subnet.zone
      subnet_id = yandex_vpc_subnet.subnet.id
    }

    # Проверка синтаксиса ругается 'Unexpected attribute: An attribute named "public_ip" is not expected here'
    # Но в свежей документации провайдера указано как раз такая конструкция 
    public_ip = true


    security_group_ids = ["${yandex_vpc_security_group.sg1.id}"]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day = tuesday
        start_time = "03:00"
        duration   = "3h"
      }
    }

    master_logging {
      enabled                    = true
      log_group_id               = yandex_logging_group.k8s_logs.id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }

  # Т.к не прод, используем один аккаунт (с ролью admin)  
  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  labels = {
    environment = "dev"
    app         = "nginx"
    purpose     = "managed-kubernetes"
  }

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = yandex_kubernetes_cluster.zonal_cluster.id
  name        = "k8s_node_group"
  version     = "1.30"

  labels = {
    "environment" = "dev"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet.id}"]
    }  

    resources {
      memory = var.node_memory
      cores  = var.node_cores
    }

    boot_disk {
      type = "network-hdd"
      size = var.node_disk_size
    }

# Прерываемые ВМ
    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min = var.min_nodes
      max = var.max_nodes
      initial = var.initial_nodes
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-d"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "tuesday"
      start_time = "06:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "thursday"
      start_time = "03:00"
      duration   = "4h30m"
    }
  }
}

# Выводим kubeconfig
output "kubeconfig" {
  value = yandex_kubernetes_cluster.cluster.kubeconfig[0].config
}