variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "machine_type" {
  description = "GCP machine type"
  type        = string
}

variable "validator_count" {
  default = 1
}

variable "observer_count" {
  default = 1
}


variable "vcpu_count" {
  description = "Number of vCPUs per instance"
  type        = number
}

variable "memory_mb" {
  description = "Memory (in MB) per instance"
  type        = number
}

variable "disk_size_gb" {
  description = "Disk size (in GB) per instance"
  type        = number
}

variable "boot_image" {
  description = "Boot image family for the instances"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vpc_name" {
  description = "Name of the existing VPC network"
  type        = string
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
}
