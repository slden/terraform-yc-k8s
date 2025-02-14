This repository contains Terraform code to deploy a Kubernetes cluster in Yandex Cloud with automatic node scaling. It also includes an Nginx deployment with pod autoscaling.

**Contents of the '.terraformrc'**
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
