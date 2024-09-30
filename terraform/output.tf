# Output the external IPs of the instances
output "instance_ips" {
  value = google_compute_instance.validator_instances.*.network_interface[0].access_config[0].nat_ip
}