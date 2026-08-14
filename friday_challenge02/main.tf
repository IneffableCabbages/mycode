/* Alta3 Research - rzfeeser@alta3.com
   An example of creating an intentional delay with Terraform. In most cases,
   doing something like this should be considered a "work-around". */

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

// if no customizations are present
// the provider block is optional
provider "null" {
  # Configuration options
}

locals {
  char_names = ["Lancelot", "Arthur", "Robin", "Zoot"]
}

resource "null_resource" "first" {

  for_each = toset(local.char_names)
  triggers = {
    name = each.value
  }
}

resource "null_resource" "second" {
  depends_on = [null_resource.first]
  provisioner "local-exec" {
    command = "echo Monty Python and the Holy Grail > holy.txt"
  }
}

resource "time_sleep" "wait_plz" {
  depends_on       = [null_resource.second]
  create_duration  = "10s" // pause this long when a creation occurs
  destroy_duration = "10s" // pause this long when a destroy occurs
}

output "characters" {
  value = null_resource.first
}
