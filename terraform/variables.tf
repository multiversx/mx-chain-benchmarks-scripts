# Define variables for customization
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (e.g., us-central1)"
  type        = string
}

variable "zone" {
  description = "GCP zone (e.g., us-central1-a)"
  type        = string
}

variable "instance_number" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "vcpu_count" {
  description = "Number of vCPUs per instance"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory (in MB) per instance"
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Disk size (in GB) per instance"
  type        = number
  default     = 50
}

variable "boot_image" {
  description = "Boot image family for the instances"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vpc_name" {
  description = "Name of the existing VPC network"
  type        = string
  default     = "multiversx-benchmark-vpc"
}

variable "subnetwork_name" {
  description = "Name of the existing subnetwork"
  type        = string
}

variable "ssh_user" {
  description = "Username for SSH access"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}