# Вывести публичный адрес, для проверки
output "nginx_public_ip" {
  description = "Public IP address of the Nginx service"
  value       = kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].ip
}

