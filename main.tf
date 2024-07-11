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
}