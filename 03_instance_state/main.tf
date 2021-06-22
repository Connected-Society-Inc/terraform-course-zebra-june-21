provider "google" {
    zone   = "us-central1-c"
}

variable "instance_name" {
    description = "The name of the compute engine instance to be provisioned"
    type        = string
    # default     = "terraform-instance"
}

# resource <resource_type> <internal_resource_id> { ... properties ... }
# Provision a GCP Compute Engine instance with a public ip address
# to have access from outside
# Link to doc of the resource: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "instance" {

    # name = "terraform-instance"
    name         = var.instance_name
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
}

output "instance_id" {
    value = google_compute_instance.instance.instance_id
}

output "instance_ip" {
    value = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}
// ...
