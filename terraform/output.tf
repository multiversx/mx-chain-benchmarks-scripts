output "validator_ips" {
  description = "Public IP addresses of the validator instances"
  value = [
    for instance in google_compute_instance.validator_instances :
    instance.network_interface[0].access_config[0].nat_ip
  ]
}

output "observer_ips" {
  description = "Public IP addresses of the observer instances"
  value = [
    for instance in google_compute_instance.observer_instances :
    instance.network_interface[0].access_config[0].nat_ip
  ]
}