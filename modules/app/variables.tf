variable "vpc_subnet_id" {
  description = "VPC Subnet ID"
  type        = string
}

variable "k8s_cluster_id" {
  description = "Kubernetes Cluster ID"
  type        = string
}

variable "database_url" {
  description = "Database connection URL"
  type        = string
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
}
