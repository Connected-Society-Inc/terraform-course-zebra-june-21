provider "google" {
    zone   = "us-central1-c"
}

variable "public_key_file" {
    description = "File containing the public ssh key to add to the instance"
    type = string
    default = "./id_rsa.pub"
}

locals {
    ssh_key = file("./id_rsa.pub")
}

# resource <resource_type> <internal_resource_id> { ... properties ... }
# Provision a GCP Compute Engine instance with a public ip address
# to have access from outside
# Link to doc of the resource: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "instance" {

    # name = "terraform-instance"
    name         = "terraform"
    machine_type = "f1-micro"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-10"
        }
    }

    network_interface {
        network = "default"
        access_config {
          // if you leave this block empty => ephemeral ip will be generated
        }
    }

    metadata = {
      # "ssh-keys" = "root:${local.ssh_key}"
      "ssh-keys" = "root:${file(var.public_key_file)}"
    }
}

output "public_ip" {
    value = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}
