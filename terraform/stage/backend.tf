terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "terraform-state-bucket-2"
    region   = "ru-central1"
    key      = "terraform.tfstate"

    # Данные Yandex Serverless Database для блокировки удаленного tfstate. Без них блокировки нет.
    # dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1guu7b8p27pq5v031iu/etn01q6lcqgdm09hrass"
    # dynamodb_table    = "tfstate-lock-table"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
