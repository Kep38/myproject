terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.131.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
  }
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  namespace  = "logging"
  chart      = "bitnami/fluentd"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "5.0.3"

  set {
    name  = "forward.enabled"
    value = "true"
  }

  set {
    name  = "forward.host"
    value = var.log_server
  }

  set {
    name  = "forward.port"
    value = var.log_port
  }

  depends_on = [kubernetes_namespace.logging]
}

