# terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#     }
#   }
# }

resource "null_resource" "reddit-app" {

  count = var.enable == "yes" ? 1 : 0

  # Добавить внутренний интерфейс в конфиг mongodb
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1/127.0.0.1,${var.db_host_internal}/g' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]
    connection {
      type        = "ssh"
      host        = var.db_host
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
  }
  # Скопировать файл сервиса на App
  provisioner "file" {
    source      = "../modules/deploy/puma.service"
    destination = "/tmp/puma.service"

    connection {
      type        = "ssh"
      host        = var.app_host
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
  }

  # Указываем DATABASE_URL
  provisioner "remote-exec" {
    inline = [
      "echo export DATABASE_URL=${var.db_host_internal}:27017 >> ~/.profile",
    ]

    connection {
      type        = "ssh"
      host        = var.app_host
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
  }

  # Запустить сервис
  provisioner "remote-exec" {
    script = "../modules/deploy/deploy.sh"

    connection {
      type        = "ssh"
      host        = var.app_host
      user        = "ubuntu"
      agent       = false
      private_key = file(var.private_key_path)
    }
  }
}
