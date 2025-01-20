output "grafana_url" {
  description = "URL of Grafana dashboard"
  value       = kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].hostname != null ? "http://${kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].hostname}" : "http://${kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].ip}"
}

output "prometheus_url" {
  description = "URL of Prometheus dashboard"
  value       = "http://${helm_release.prometheus.name}-prometheus-server.${helm_release.prometheus.namespace}.svc.cluster.local"
}

output "grafana_access_info" {
  description = "Grafana access information"
  value       = <<EOF
To access Grafana:

1. If you are using Ingress:
   - Open your browser and go to: ${kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].hostname != null ? "http://${kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].hostname}" : "http://${kubernetes_ingress_v1.grafana_ingress.status[*].load_balancer[*].ingress[0].ip}"}

2. If you are not using Ingress (e.g., using port-forwarding):
   - Run the following command to forward port 3000 to your local machine:
     kubectl port-forward -n ${kubernetes_namespace.monitoring.metadata[0].name} svc/${helm_release.grafana.name} 3000:80
   - Open your browser and go to: http://localhost:3000

Login with username 'admin' and password specified in your 'grafana-values.yaml' (or a generated one, check the Grafana logs).
EOF
}