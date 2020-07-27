# refer to a resource group
data "azurerm_resource_group" "test" {
  name     = "${var.resource_group_name}"
  #location = "${var.location}"
  #tags     = "${var.tags}"
}


# refer to a subnet
data "azurerm_subnet" "test" {
  name                 = "${var.subnet}"
  virtual_network_name = "${var.virtual_network}"
  resource_group_name  = "${var.resource_group_name_vn}"
}


provider "random" {
  version = "~> 1.0"
}

resource "random_id" "vm-sa" {
  keepers = {
    vm_hostname = "${var.vm_hostname}"
  }

  byte_length = 6
}

#module "ipconfig"{
#       source = "../ipconfig"
#}

#module "winvm"{
#       source = "../winvm"
#}


module "os"{
  source       = "../os"
  vm_os_simple = "${var.vm_os_simple}"
}



resource "azurerm_availability_set" "as" {
  name                         = "${var.vm_hostname}-avset"
  location                     = "${data.azurerm_resource_group.test.location}"
  resource_group_name          = "${data.azurerm_resource_group.test.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
  #tags                         = "${var.tags}"
}


# create a network interface
resource "azurerm_network_interface" "vm_nic" {
  count               = "${var.nb_instances}"
  name                = "nic-${var.vm_hostname}${count.index}"
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "${data.azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
      }
}




resource "azurerm_storage_account" "vm-sa" {
  count                    = "${var.boot_diagnostics == "true" ? 1 : 0}"
  name                     = "bootdiag${lower(random_id.vm-sa.hex)}"
  resource_group_name      = "${data.azurerm_resource_group.test.name}"
  location                 = "${var.location}"
  account_tier             = "${element(split("_", var.boot_diagnostics_sa_type),0)}"
  account_replication_type = "${element(split("_", var.boot_diagnostics_sa_type),1)}"
  #tags                     = "${var.tags}"
}



resource "azurerm_virtual_machine" "vm-linux" {
  count                 =  "${!contains(list("${var.vm_os_simple}","${var.vm_os_offer}"), "WindowsServer") && var.is_windows_image != "true" && var.data_disk == "false" ? var.nb_instances : 0}"
  name                  = "${var.vm_hostname}${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  network_interface_ids = ["${element(azurerm_network_interface.vm_nic.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"
  availability_set_id   = "${azurerm_availability_set.as.id}"
  #ip_address    = "${azurerm_network_interface.vm_nic.id}"
  #count = 2

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id        = "${var.vm_os_id}"
    publisher = "${var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""}"
    offer     = "${var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""}"
    sku       = "${var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""}"
    version   = "${var.vm_os_id == "" ? var.vm_os_version : ""}"
  }

  storage_os_disk {
    name              = "osdisk-${var.vm_hostname}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type =  "${var.storage_account_type}"
  }

  #storage_data_disk {
  #  name              = "datadisk-${var.vm_hostname}-${count.index}"
  #  create_option     = "Empty"
  #  lun               = 0
  #  disk_size_gb      = "${var.data_disk_size_gb}"
  #  managed_disk_type = "${var.data_sa_type}"
  #}

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${var.custom_data}"
  }
  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }

  provisioner "local-exec" {
    environment {
      #PUBLIC_IP  = "${self.ipv4_address}"
      #PRIVATE_IP = "10.251.172.48"
    }

    #working_dir = "./ansible"
    #command     = "ansible-playbook -u azureadmin--private-key ${var.private_key} playbooks/roles/arrow/tasks/user1.yml -i 10.251.172.48,"
    command      = "ansible-playbook -u azureadmin --private-key ${var.private_key} playbooks/roles/arrow/tasks/user1.yml  -i 10.251.172.48,"
    #${self.ipv4_address_private}
  }

  provisioner "remote-exec" {
    inline = [
      "yum update -y",
    ]

    connection {
      #host        = "${self.ipv4_address_private}"
      host        = "10.251.172.48"
      type        = "ssh"
      user        = "azureadmin"
      #private_key = "${file("~/.ssh/terraform_rsa")}"
      private_key = "${var.private_key}"
    }
  }

  boot_diagnostics {
    enabled     = "${var.boot_diagnostics}"
    storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint): "" }"
  }

}

resource "azurerm_virtual_machine" "vm-linux-with-datadisk" {
  count                 = "${!contains(list("${var.vm_os_simple}","${var.vm_os_offer}"), "WindowsServer") && var.is_windows_image != "true" && var.data_disk == "true" ? var.nb_instances : 0}"
  name                  = "${var.vm_hostname}${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.test.name}"
  network_interface_ids = ["${element(azurerm_network_interface.vm_nic.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"
  availability_set_id   = "${azurerm_availability_set.as.id}"
  #ip_address    = "${azurerm_network_interface.vm_nic.id}"
  #count = 2
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
  storage_image_reference {
    id        = "${var.vm_os_id}"
    publisher = "${var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""}"
    offer     = "${var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""}"
    sku       = "${var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""}"
    version   = "${var.vm_os_id == "" ? var.vm_os_version : ""}"
  }
  storage_os_disk {
    name              = "osdisk-${var.vm_hostname}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type =  "${var.storage_account_type}"
  }
  storage_data_disk {
    name              = "datadisk-${var.vm_hostname}-${count.index}"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "${var.data_disk_size_gb}"
    managed_disk_type = "${var.data_sa_type}"
  }
  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${var.custom_data}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      #path     = "/root/.ssh/id_rsa"
      #key_data = "${file("${var.ssh_key}")}"
      key_data = "${file("${var.ssh_key}")}"
    }
  }
  connection {
    host       = "${azurerm_network_interface.vm_nic.private_ip_address}"
    type        = "ssh"
    user        = "azureadmin"
    agent       = "false"
    private_key = "${file("~/.ssh/terraform_rsa")}"
    #private_key = "${file("~/.ssh/id_rsa")}"
    #timeout = "300s"
    #on_failure   = "continue"
    #private_key = "${var.private_key}"
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/azureadmin/.ssh && touch deploy_key.sh",
    ]
  }
  provisioner "file" {
    #source = "${file("~/.ssh/deploy_key.sh")}"
    source = "${"~/.ssh/deploy_key.sh"}"
    destination = "/home/azureadmin/.ssh/deploy_key.sh"
    on_failure   = "continue"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${var.admin_password} | sudo -S sh /home/azureadmin/.ssh/deploy_key.sh",
      #"cd /home/azureadmin/.ssh/ && sh deploy_key.sh",
      #"sudo yum update -y",
    ]
    on_failure   = "continue"
  }

  provisioner "local-exec" {
    environment {
      #PRIVATE_IP = "${azurerm_network_interface.vm_nic.*.private_ip_address}"
    }

    #working_dir = "./linuxvm"
    #command     = "ansible-playbook playbooks/roles/arrow/tasks/user1.yml -u azureadmin --private-key ~/.ssh/terraform_rsa -i 10.251.172.48,"
    #command      = "ansible-playbook -u azureadmin --private-key ${var.private_key} playbooks/roles/arrow/tasks/user1.yml  -i ${azurerm_network_interface.vm_nic.private_ip_address},"
    command      = "echo ${azurerm_network_interface.vm_nic.private_ip_address}  >> /etc/ansible/infrastructure/ansible/inventories/dev/hybris_dev"
    on_failure   = "continue"
  }

  provisioner "local-exec" {
    environment {
    }
    command      = "ansible-playbook -i ../inventories/dev/hybris_dev ../playbooks/roles/arrow/tasks/user.yml --private-key=~/.ssh/terraform_rsa"
    #command      = "ansible-playbook -i ../inventories/dev/hybris_dev ../playbooks/roles/arrow/tasks/main.yml --private-key=~/.ssh/terraform_rsa"
    on_failure   = "continue"
  }


  provisioner "local-exec" {
    environment {
    }
    command      = "mv terraform.tfstate terraform.tfstate.bk${count.index}.${timestamp()}"
    on_failure   = "continue"
  }


  boot_diagnostics {
    enabled     = "${var.boot_diagnostics}"
    storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint): "" }"
  }
}



