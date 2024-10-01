output "instance_ips" {
  value = [for instance in google_compute_instance.validator_instances : instance.network_interface[0].access_config[0].nat_ip]
}
