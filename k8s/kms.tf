# KMS ключ для шифрования данных Kubernetes
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "k8s-symetric-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}