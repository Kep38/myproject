variable "prometheus_scrape_interval" {
  description = "Интервал сбора метрик"
  default     = "30s"
}

variable "grafana_admin_password" {
  description = "Пароль для входа в Grafana"
  type        = string
  sensitive   = true
}

variable "smtp_server" {
  description = "SMTP сервер для Alertmanager"
  type = string
}

variable "smtp_user" {
  description = "SMTP пользователь"
  type        = string
  sensitive   = true
}

variable "smtp_password" {
  description = "SMTP пароль"
  type        = string
  sensitive   = true
}

variable "alertmanager_email" {
  description = "Email для Alertmanager"
  type = string
}