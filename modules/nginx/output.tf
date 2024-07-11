output "ip_docker" {
  value = docker_container.nginx.ip_address
}

output "volume_id" {
  value = docker_volume.loisvol.driver_opts.device
}