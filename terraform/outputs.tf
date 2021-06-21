output "external_ip_address_app-1" {
  value = [
      for addr in yandex_compute_instance.app[*]:
      addr.network_interface.0.nat_ip_address if addr.name == "reddit-app-1"
      ][0]
}
output "external_ip_address_app-2" {
  value = [
      for addr in yandex_compute_instance.app[*]:
      addr.network_interface.0.nat_ip_address if addr.name == "reddit-app-2"
      ][0]
}
output "external_ip_address_lb" {
  value = [
    for vars in yandex_lb_network_load_balancer.reddit-load.listener :
    vars.external_address_spec[*].address if vars.name == "reddit-app-listener"
  ][0][0]
}
