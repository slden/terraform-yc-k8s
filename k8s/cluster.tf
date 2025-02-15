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
    # UPD ошибки  ушли при 'terraform init' - language server не знал, какие атрибуты есть у ресурса, не видел провайдера
    public_ip = true


    security_group_ids = ["${yandex_vpc_security_group.sg1.id}"]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = tuesday
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
