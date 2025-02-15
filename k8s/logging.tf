resource "yandex_logging_group" "k8s_logs" {
  name        = "k8s_logs"
  description = "Log group for Kubernetes master logs"
  folder_id   = var.folder_id
}
