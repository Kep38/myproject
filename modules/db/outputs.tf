output "hostname" {
  description = "Database hostname"
  value       = yandex_mdb_postgresql_cluster.db_cluster.host[0].fqdn
}

output "port" {
  description = "Database port"
  value       = 5432 #  порт БД,стандарт.
}

output "name" {
  description = "Database name"
  value       = var.database_name
}

output "username" {
  description = "Database username"
  value       = var.database_user
}

output "password" {
  description = "Database password"
  value       = var.database_password
  sensitive   = true
}