variable "subnet_name" {
  description = "Name of the VPC subnet"
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "CIDR block for the VPC subnet"
  type        = string
  default     = null
}

variable "zone" {
  description = "Zone for resources"
  type        = string
  default     = null
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = null
}

variable "database_user" {
  description = "Database user"
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of Kubernetes nodes"
  type        = number
  default     = null
}

variable "node_disk_size" {
  description = "Disk size for each node"
  type        = number
  default     = null
}

variable "node_memory" {
  description = "Memory size for each node"
  type        = number
  default     = null
}

variable "node_cores" {
  description = "Number of CPU cores for each node"
  type        = number
  default     = null
}

variable "master_version" {
  description = "Kubernetes master version"
  type        = string
  default     = null
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = null
}

variable "log_server" {
  description = "Адрес сервера для логов"
  type        = string
  default     = null
}

variable "log_port" {
  description = "Порт сервера для логов"
  type        = number
  default     = null
}
variable "k8s_folder_id" {
  description = "Folder ID for k8s cluster"
  type        = string
  default     = null
}