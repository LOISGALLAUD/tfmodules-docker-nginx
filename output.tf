output "nginx_ip_container" {
  value = module.nginx.ip_address
}

output "nginx_volume_id" {
  value = module.wordpress.volume_id
}

output "wordpress_ip_container" {
  value = module.wordpress.wordpress_ip
}

output "wordpress_db_ip" {
  value = module.wordpress.db_ip
}

output "wordpress_volume_id" {
  value = module.wordpress.db_volume
}