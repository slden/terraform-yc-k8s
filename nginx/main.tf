terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Разворачивание Nginx
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = var.nginx_image

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# LoadBalancer для Nginx
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }
    type = "LoadBalancer"

    port {
      port        = var.service_port
      target_port = 80
    }
  }
}

# HPA для Nginx
# Вот тут немножко погулить пришлось :) Нужно именно v2 использовать, иначе ловил ошибку
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
          type               = "Utilization"
          average_utilization = var.hpa_target_cpu_utilization_percentage
        }
      }
    }
  }
}