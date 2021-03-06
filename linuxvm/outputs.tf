output "vm_ids" {
 description = "Virtual machine ids created."
 value       = "${concat(azurerm_virtual_machine.vm-linux.*.id)}"
}

#output "network_security_group_id" {
#  description = "id of the security group provisioned"
#  value       = "${azurerm_network_security_group.vm.id}"
#}


output "network_interface_id" {
  description = "ids of the vm nics provisoned."
  value       = "${azurerm_network_interface.vm_nic.*.id}"
}


output "network_interface_ip_address" {
  description = "privateof the vm nics provisoned."
  value       = "${azurerm_network_interface.vm_nic.*.private_ip_address}"
}



#output "public_ip_id" {
#  description = "id of the public ip address provisoned."
#  value       = "${azurerm_public_ip.vm.*.id}"
#}

#output "public_ip_address" {
#  description = "The actual ip address allocated for the resource."
#  value       = "${azurerm_public_ip.vm.*.ip_address}"
#}

#output "public_ip_dns_name" {
#  description = "fqdn to connect to the first vm provisioned."
#  value       = "${azurerm_public_ip.vm.*.fqdn}"
#}

output "availability_set_id" {
  description = "id of the availability set where the vms are provisioned."
  value       = "${azurerm_availability_set.as.id}"
}


output "subnet_id" {
  description = "subnet id for given VM"
  value = "${data.azurerm_subnet.test.id}"
}

output "azurerm_resource_group_id" {
  description = "Resource FGFroup ID ..."
  value = "${data.azurerm_resource_group.test.id}"
}





