variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "image_id" {
  description = "Disk image"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "private_key_path" {
  description = "Path to private key file used for ssh access"
}
variable "region_id" {
  description = "Region id"
}
variable "number" {
  description = "Virtual machine count"
}
variable "app_disk_image" {
  description = "Disk image for reddit app"
}
variable "db_disk_image" {
  description = "Disk image for reddit db"
}
variable "app_name" {
  description = "App name"
}
variable "db_name" {
  description = "DB name"
}
variable "enable" {
  description = "Type 'yes' if u want to install reddit-app"
  type        = string
}
