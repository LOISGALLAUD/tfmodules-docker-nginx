resource "null_resource" "ssh_target" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }
  provisioner "remote_ssh" {
    inline = [
      "sudo mkdir -p /srv/wordpress",
      "sudo chmod 777 /srv/wordpress",
      "sleep 5s",
    ]
  }
}

provider "docker" {
  host = "tcp://${var.ssh_host}:2375"
}

resource "docker_volume" "db_data" {
  name   = "db_data"
  driver = "local"
  driver_opts {
    type   = "none"
    o      = "bind"
    device = "/srv/wordpress"
  }
  depends_on = [null_resource.ssh_target]
}

resource "docker_network" "wordpress_net" {
  name = "wordpress_net"
}

resource "docker_container" "db" {
  name    = "db"
  image   = "mysql:5.7"
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=wordpress",
    "MYSQL_PASSWORD=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_DATABASE=wordpress",
  ]
  networks_advanced {
    name = docker_network.wordpress_net.name
  }
  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/mysql"
    read_only      = false
  }
}

resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

resource "docker_container" "wordpress" {
  name    = "wordpress"
  image   = docker_image.wordpress.latest
  restart = "always"
  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_PASSWORD=wordpress",
  ]
  networks_advanced {
    name = docker_network.wordpress_net.name
  }
  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/www/html"
    read_only      = false
  }
  ports {
    internal = 80
    external = var.wordpress_port
  }
}