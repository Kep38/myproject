terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.131.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name       = "k8s-cluster"
  network_id = var.existing_vpc_network_id
  folder_id  = var.folder_id

  master {
    version = var.master_version
    # public_ip = true
    zonal {
      zone      = var.zone
      subnet_id = var.vpc_subnet_id
    }
  }

  service_account_id  = var.service_account_id
  node_service_account_id = var.node_service_account_id
}

resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "node-group"
  version    = var.master_version

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  instance_template {
    resources {
      memory = var.node_memory
      cores  = var.node_cores
    }

    boot_disk {
      type = "network-ssd"
      size = var.node_disk_size
    }

    network_interface {
      subnet_ids = [var.vpc_subnet_id]
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }
}

# Проверка доступности API
resource "null_resource" "check_k8s_api" {
  depends_on = [yandex_kubernetes_node_group.k8s_nodes]

  provisioner "local-exec" {
    command = <<EOT
timeout 60s bash -c '
while true; do
  yc managed-kubernetes cluster get ${yandex_kubernetes_cluster.k8s_cluster.id} --format=json
  if [[ $? -eq 0 ]]; then
    kubectl get namespace default
    if [[ $? -eq 0 ]]; then
      break
    fi
  fi
  echo "Waiting for Kubernetes API to become available..."
  sleep 10
done
'
EOT
    interpreter = ["bash", "-c"]
  }
}

# Обновление kubeconfig
resource "null_resource" "update_kubeconfig" {
  depends_on = [null_resource.check_k8s_api]

  provisioner "local-exec" {
    command     = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s_cluster.id} --external" # Уберите --force, если не хотите перезаписывать существующий контекст
    interpreter = ["bash", "-c"]
  }
}

data "external" "k8s_token" {
  program = ["bash", "-c", "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s_cluster.id} --external && cat ~/.kube/config | yq -r '.users[0].user.auth-provider.config.access-token'"]
}