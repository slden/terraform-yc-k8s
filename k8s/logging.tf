resource "yandex_logging_group" "k8s_logs" {
  # Название может содержать только буквы, цифры и "-"
  name        = "k8s-logs"
  description = "Log group for Kubernetes master logs"
  folder_id   = var.folder_id
}
