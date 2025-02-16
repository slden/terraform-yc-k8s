# # Выводим kubeconfig
# output "kubeconfig" {
#   value = yandex_kubernetes_cluster.zonal_cluster.kubeconfig_raw
# }

# Отдаем команду для того чтобы скачать kubeconfig
output "external_cluster_cmd" {
  value = "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.zonal_cluster.id} --external"
}
