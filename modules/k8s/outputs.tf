output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.name
}

output "k8s_cluster_ca_certificate" {
  description = "CA certificate for the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.master.0.cluster_ca_certificate
}

output "k8s_cluster_external_v4_endpoint" {
  description = "External IPv4 endpoint of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.master.0.external_v4_endpoint
}

output "k8s_token" {
  value = data.external.k8s_token.result.stdout
}