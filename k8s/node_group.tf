resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id = yandex_kubernetes_cluster.zonal_cluster.id
  # Название может содержать только буквы, цифры и "-"
  name       = "k8s-node-group"
  version    = "1.30"

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
      min     = var.min_nodes
      max     = var.max_nodes
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
