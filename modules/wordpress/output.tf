output "db_ip" {
  value = docker_container.db.ip_address
}
output "wordpress_ip" {
  value = docker_container.wordpress.ip_address
}
output "db_volume" {
  value = docker_volume.db_data.driver_opts.device
}