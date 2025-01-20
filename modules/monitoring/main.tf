resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "56.2.1"
  provider         = helm

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [kubernetes_namespace.monitoring]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  chart            = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  version          = "7.3.9"
  provider         = helm

  values = [
    file("${path.module}/grafana-values.yaml")
  ]

  set {
    name = "admin.password"
    value = var.grafana_admin_password
  }

  depends_on = [kubernetes_namespace.monitoring]
}

resource "kubernetes_ingress_v1" "grafana_ingress" {
  wait_for_load_balancer = true
  provider               = kubernetes
  metadata {
    name      = "grafana-ingress"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      host = "grafana.your-domain.com"
      http {
        path {
          backend {
            service {
              name = helm_release.grafana.name
              port {
                number = 80
              }
            }
          }
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
  depends_on = [helm_release.grafana]
}

