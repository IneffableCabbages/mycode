/* main.tf
Alta3 Research - rzfeeser@alta3.com
SOLUTION 01 - Creating 3 containers to match setup.sh */


# terraform block
terraform {
  required_providers {
    docker = { 
      source  = "kreuzwerker/docker"
      version = "~> 4.0.0"
    }   
  }
}

# interact with docker
provider "docker" {}

resource "docker_network" "ansible-net" {
  name = "ansible-net"
  ipam_config {
    subnet  = "10.10.2.0/24"
    gateway = "10.10.2.1" # Explicitly match what Docker defaults to
  }
}

## fry - 10.10.2.4
resource "docker_image" "fry" {
  name         = "ssh-fry:latest"
  keep_locally = true
  build {
    context = "." 
    tag = ["ssh-fry"]
    build_args = { 
      user : "fry"
    }   
  }
}

resource "docker_container" "fry" {
  name = "fry"
  image = docker_image.fry.name
  network_mode = "bridge"
  hostname = "fry"

  networks_advanced {
    name = docker_network.ansible-net.name
    aliases = ["ansible-net"]
    ipv4_address = "10.10.2.4"  
  }
}

## bender - 10.10.2.3
resource "docker_image" "bender" {
  name         = "ssh-bender:latest"
  keep_locally = true
  build {
    context = "." 
    tag = ["ssh-bender"]
    build_args = { 
      user : "bender"
    }   
  }
}

resource "docker_container" "bender" {
  name = "bender"
  image = docker_image.bender.name
  network_mode = "bridge"
  hostname = "bender"

  networks_advanced {
    name = docker_network.ansible-net.name
    aliases = ["ansible-net"]
    ipv4_address = "10.10.2.3"
  }
}

## zoidberg - 10.10.2.5
resource "docker_image" "zoidberg" {
  name         = "ssh-zoidberg:latest"
  keep_locally = true
  build {
    context = "."
    tag = ["ssh-zoidberg"]
    build_args = {
      user : "zoidberg"
    }
  }
}

resource "docker_container" "zoidberg" {
  name = "zoidberg"
  image = docker_image.zoidberg.name
  network_mode = "bridge"
  hostname = "zoidberg"

  networks_advanced {
    name = docker_network.ansible-net.name
    aliases = ["ansible-net"]
    ipv4_address = "10.10.2.5"
  }
}
