terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = var.subnet_id
  app_name        = var.app_name
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = var.subnet_id
  db_name         = var.db_name
}

module "deploy" {
  source           = "../modules/deploy"
  private_key_path = var.private_key_path
  app_host         = module.app.external_ip_address_app
  db_host          = module.db.external_ip_address_db
  db_host_internal = module.db.internal_ip_address_db
  enable           = var.enable
}
