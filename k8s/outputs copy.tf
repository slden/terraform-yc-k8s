# Выводим kubeconfig
output "kubeconfig" {
  value = yandex_kubernetes_cluster.zonal_cluster.kubeconfig[0].config
}
