/* main.tf
   Alta3 Research - rzfeeser@alta3.com */

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.2"
    }
  }
}

# interact with docker
provider "docker" {
  # Explicitly points to the standard Ubuntu Docker socket
  host = "unix:///var/run/docker.sock"
}

# create random_ resources
provider "random" {}

# interact with time data
provider "time" {}

resource "docker_image" "nginx" {
  name         = "nginx:1.28"
  keep_locally = true
}

# available from random.random_pet
resource "random_pet" "nginx" {
  length    = 3
  separator = "_"
}

resource "docker_container" "nginx" {
  count        = 3
  image        = docker_image.nginx.image_id
  network_mode = "bridge"
  name         = "nginx-${random_pet.nginx.id}-${count.index}"
  # name = "nginx-hoppy-frog-0"

  ports {
    internal = 80
    # 8000, 8001, 8002, 8003
    external = 8000 + count.index
  }
}

output "nginx_hosts" {
  value = [for container in docker_container.nginx : { name : container.name, host : "${container.ports[0].ip}:${container.ports[0].external}" }]
}
