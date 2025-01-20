variable "vpc_subnet_id" {
  description = "ID of the VPC subnet"
  type        = string
}

variable "vpc_network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_user" {
  description = "Database user"
  type        = string
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Zone for the database"
  default     = "ru-central1-a"
}

variable "folder_id" {
  description = "Folder ID"
  type = string
}