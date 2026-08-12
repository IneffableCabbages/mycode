# main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0.0"
    }
  }
}

provider "docker" {
# Explicitly points to the standard Ubuntu Docker socket
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.23.4"
  keep_locally = true       // keep image after "destroy"
}
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  network_mode = "bridge"
  name  = var.container_name
  ports {
    internal = 80
    external = 8089
  }
}
