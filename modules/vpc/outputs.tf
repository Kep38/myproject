output "vpc_network_id" {
  value = yandex_vpc_network.network.id
}

output "vpc_subnet_id" {
  value = yandex_vpc_subnet.subnet.id
}