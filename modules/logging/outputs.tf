output "fluentd_release" {
  value = helm_release.fluentd.name
}

output "fluentd_status" {
  description = "Статус развертывания Fluentd"
  value       = helm_release.fluentd.status
}
