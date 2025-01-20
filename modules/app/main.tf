resource "kubernetes_namespace" "app" {
  metadata {
    name = "earthquake-app"
  }
}

  resource "kubernetes_deployment" "app" {
  metadata {
    name      = "earthquake-app"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "earthquake-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "earthquake-app"
        }
      }

      spec {
        container {
          image = var.app_image
          name  = "earthquake-app"

          env {
            name  = "DATABASE_URL"
            value = var.database_url
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "earthquake-app"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "earthquake-app"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
