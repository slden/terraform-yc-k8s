This repository contains Terraform code to deploy a Kubernetes cluster (managed) in Yandex Cloud with automatic node scaling. It also includes an Nginx deployment with pod autoscaling.

**Requirements:**
- yc (cli)
- terraform (cli)
- kubectl


**Init for Yandex.Cloud:**
```
yc config set service_account_key_file k8s/authorized_key.json
yc config set cloud-id ${var.cloud_id}
yc config set folder-id ${var.folder_id}
```

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
