# # Выводим kubeconfig
# output "kubeconfig" {
#   value = yandex_kubernetes_cluster.zonal_cluster.kubeconfig_raw
# }

# Выводим команды для инита в облако
# Отдаем команду для того чтобы скачать kubeconfig
output "cluster_cmds" {
  value = <<EOT
yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.zonal_cluster.id} --external
EOT
}