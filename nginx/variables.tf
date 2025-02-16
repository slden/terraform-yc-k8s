variable "kubeconfig_path" {
  description = "Path to the kubeconfig file to access the cluster"
  type        = string
}

variable "nginx_image" {
  description = "Image for nginx"
  type        = string
  default     = "nginx:1.21.6"
}

variable "replicas" {
  description = "Initial number of replicas for deployment"
  type        = number
  default     = 1
}

variable "service_port" {
  description = "Port on which the service will be available"
  type        = number
  default     = 80
}

variable "hpa_min_replicas" {
    description = "Minimum number of replicas for HPA"
    type = number
    default = 1
}

variable "hpa_max_replicas" {
    description = "Maximum number of replicas for HPA"
    type = number
    default = 5
}

variable "hpa_target_cpu_utilization_percentage" {
    description = "Target CPU load (percentage) for pod autoscaler"
    type = number
    default = 50
}