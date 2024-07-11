terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}


variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

module "docker" {
  source   = "./modules/docker"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key
}

module "nginx" {
  source   = "./modules/nginx"
  ssh_host = var.ssh_host
  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key
}

module "wordpress" {
  source         = "./modules/wordpress"
  ssh_host       = var.ssh_host
  ssh_user       = var.ssh_user
  ssh_key        = var.ssh_key
  wordpress_port = 8080
}