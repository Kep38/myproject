variable "cloud_id" {
  description = "Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Folder ID"
  type        = string
}

variable "zone" {
  description = "Zone for resources"
  default     = "ru-central1-a"
}

variable "log_server" {
  description = "Адрес сервера для логов"
  type        = string
}

variable "log_port" {
  description = "Порт сервера для логов"
  default     = 24224
}

variable "k8s_host" {
  type = string
}

variable "k8s_token" {
  type = string
}

variable "k8s_cluster_ca_certificate" {
  type = string
}

variable "token" {
  description = "Yandex Cloud API Token"
  type        = string
}