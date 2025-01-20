variable "subnet_name" {
  description = "Name of the VPC subnet"
  default     = "vpc-subnet"
}

variable "cidr_block" {
  description = "CIDR block for the VPC subnet"
  default     = "10.1.0.0/24"
}

variable "zone" {
  description = "Zone for the VPC subnet"
  default     = "ru-central1-a"
}