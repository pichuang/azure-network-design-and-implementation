output "public-ip-vnet-1" {
  value = "${azurerm_linux_virtual_machine.vm-hub-1.name} Public IP: ${azurerm_public_ip.public-ip-vnet-1.ip_address}"
}

output "private-ip-vnet-1" {
  value = "${azurerm_linux_virtual_machine.vm-hub-1.name} Private IP: ${azurerm_network_interface.nic-vnet-1.private_ip_address}"
}

output "public-ip-vnet-2" {
  value = "${azurerm_linux_virtual_machine.vm-hub-2.name} Public IP: ${azurerm_public_ip.public-ip-vnet-2.ip_address}"
}

output "private-ip-vnet-2" {
  value = "${azurerm_linux_virtual_machine.vm-hub-2.name} Private IP: ${azurerm_network_interface.nic-vnet-2.private_ip_address}"
}

output "public-ip-vnet-3" {
  value = "${azurerm_linux_virtual_machine.vm-hub-3.name} Public IP: ${azurerm_public_ip.public-ip-vnet-3.ip_address}"
}

output "private-ip-vnet-3" {
  value = "${azurerm_linux_virtual_machine.vm-hub-3.name} Private IP: ${azurerm_network_interface.nic-vnet-3.private_ip_address}"
}

output "public-bastion-ip" {
  value = "Bastion SSH: ssh ${var.admin_username}@${azurerm_public_ip.public-ip-bastion.ip_address} -i ~/.ssh/poc-ms"
}


