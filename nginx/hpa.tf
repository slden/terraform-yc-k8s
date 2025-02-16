# HPA для Nginx
# Вот тут немножко погулить пришлось :) Нужно именно v2 использовать, иначе ловил ошибку
# Для того чтобы HPA мог вычислять процент использования CPU, должны быть заданы resources.requests для деплоймента Nginx
resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx" {
  metadata {
    name = "nginx-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    min_replicas = var.hpa_min_replicas
    max_replicas = var.hpa_max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.hpa_target_cpu_utilization_percentage
        }
      }
    }

    behavior {
      scale_up {
        stabilization_window_seconds = 0
        select_policy                = "Max"
        policy {
          type          = "Pods"
          value         = 4
          period_seconds = 15
        }
        policy {
          type          = "Percent"
          value         = 100
          period_seconds = 15
        }
      }
      scale_down {
        select_policy = "Max"
        policy {
          type          = "Percent"
          value         = 100
          period_seconds = 15
        }
      }
    }
  }
}
