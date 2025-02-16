# Деплоим metrics-server
resource "kubernetes_manifest" "metrics_server" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "metrics-server"
      namespace = "kube-system"
      labels = {
        k8s-app = "metrics-server"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          k8s-app = "metrics-server"
        }
      }
      template = {
        metadata = {
          labels = {
            k8s-app = "metrics-server"
          }
        }
        spec = {
          containers = [{
            name  = "metrics-server"
            image = "registry.k8s.io/metrics-server/metrics-server:v0.6.4"
            args  = ["--kubelet-insecure-tls"]
          }]
        }
      }
    }
  }
}
