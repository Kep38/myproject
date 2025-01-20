output "app_service_url" {
  description = "URL of the application service"
  value       = "http://${kubernetes_service.app.metadata[0].name}.${kubernetes_namespace.app.metadata[0].name}.svc.cluster.local"
}

output "app_deployment_name" {
  description = "Name of the application deployment"
  value       = kubernetes_deployment.app.metadata[0].name
}
