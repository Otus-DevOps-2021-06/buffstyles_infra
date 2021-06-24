variable "private_key_path" {
  description = "Path to private key file used for ssh access"
}
variable "app_host" {
  description = "App VM IP address"
}
variable "db_host" {
  description = "DB VM external IP address"
}
variable "db_host_internal" {
  description = "DB VM internal IP address"
}
variable "enable" {
  type        = string
  description = "Type 'yes' if u want to install reddit-app"
}
