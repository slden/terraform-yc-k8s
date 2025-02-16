# Создаем VPC-сеть
resource "yandex_vpc_network" "vpc" {
  name        = "my-vpc-network"
  description = "VPC network for the K8s cluster"
}

# Описание Security group
resource "yandex_vpc_security_group" "sg1" {
  name        = "sg1"
  description = "Security group for vpc network resources"
  network_id  = yandex_vpc_network.vpc.id

  labels = {
    environment = "dev"
    project     = "k8s-cluster-demo"
  }

# Разрешаем входящий HTTP-трафик из Интернета
  ingress {
    protocol       = "TCP"
    description    = "Allow incoming HTTP traffic from Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 80
    to_port        = 80
  }

  # Разрешаем входящий HTTPS-трафик из Интернета
  ingress {
    protocol       = "TCP"
    description    = "Allow incoming HTTPS traffic from Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 443
    to_port        = 443
  }

  # Разрешаем входящие соединения от узлов кластера 
  ingress {
    protocol       = "TCP"
    description    = "Allow kubelet communication within the cluster"
    v4_cidr_blocks = [var.subnet_cidr]
    from_port      = 10250
    to_port        = 10250
  }

  # Исходящий трафик

  # Разрешаем исходящий HTTP-трафик
  egress {
    protocol       = "TCP"
    description    = "Allow outgoing HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 80
    to_port        = 80
  }

  # Разрешаем исходящий HTTPS-трафик
  egress {
    protocol       = "TCP"
    description    = "Allow outgoing HTTPS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 443
    to_port        = 443
  }

  # Разрешаем исходящий DNS-трафик
  egress {
    protocol       = "UDP"
    description    = "Allow outgoing DNS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 53
    to_port        = 53
  }

  # Разрешаем весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }  
}

# Создаем subnet
resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.subnet_cidr]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vpc.id
}
