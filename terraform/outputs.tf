output "external_ip_address_app" {
  value = [
    for addr in yandex_compute_instance.app[*] :
    addr.network_interface.0.nat_ip_address
  ]
}
output "external_ip_address_load_balancer" {
  value = [
    for vars in yandex_lb_network_load_balancer.reddit-load.listener :
    vars.external_address_spec[*].address if vars.name == "reddit-app-listener"
  ][0][0]
}
