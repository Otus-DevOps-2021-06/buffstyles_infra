# terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#     }
#   }
# }

resource "yandex_compute_instance" "app" {

  allow_stopping_for_update = true
  name                      = var.app_name

  labels = {
    tags = "reddit-app"
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
