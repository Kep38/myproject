variable "vpc_subnet_id" {
  description = "ID of the VPC subnet"
  type        = string
}

variable "existing_vpc_network_id" {
  description = "ID of the existing VPC network"
  type        = string
}

variable "node_count" {
  description = "Number of Kubernetes nodes"
  type        = number
  default     = 3
}

variable "node_disk_size" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 30
}

variable "node_memory" {
  description = "Memory for nodes in GB"
  type        = number
  default     = 8
}

variable "node_cores" {
  description = "Number of CPU cores for nodes"
  type        = number
  default     = 2
}

variable "master_version" {
  description = "Version of Kubernetes master"
  type        = string
  default     = "1.28.4"
}

variable "zone" {
  description = "Zone for Kubernetes cluster"
  type        = string
  default     = "ru-central1-a"
}

variable "service_account_id" {
  description = "Service account ID for the cluster"
  type        = string
}

variable "node_service_account_id" {
  description = "Service account ID for the nodes"
  type        = string
}

variable "folder_id" {
  description = "Folder ID"
  type        = string
}