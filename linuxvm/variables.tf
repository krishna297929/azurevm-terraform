variable "private_key" {
    type = "string"
    default = "~/.ssh/terraform_rsa"
}


variable "resource_group" {
description = " uw1_dev_arwver_infrastructure  as an example"
 default = "uw1_dev_arwver_infrastructure"
}


variable "vm_size" {
  description = "Specifies the size of the virtual machine. Eg:Standard_DS1_V2 "
  default     = "Standard_DS1_V2"
}



#variable "tags" {
#  type        = "map"
#  description = "A map of the tags to use on the resources that are deployed with this module."

#  default = {
#    source = "arrow"
#  }
#}

variable "subnet" {
      description =  "enter subnet id eg:digital_sb_10_251_172_0_22 "
       default = "digital_sb_10_251_172_0_22"
}



variable "virtual_network" {
  description = "The virtual network name for subnet"
  default     = "digital_vnet2"
}


variable "resource_group_name_vn" {
  description = "The RG for Vn "
  default     = "digital_vnet"
}



variable "admin_username" {
  description = "The admin username of the VM that will be deployed"
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure"
  default     = "admin_password"
}

variable "nb_instances" {
  description = "Specify the number of vm instances"
  #default     = "1"
}


variable "custom_data" {
  description = "The custom data to supply to the machine. This can be used as a cloud-init for Linux systems."
  default     = ""
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}



variable "vm_hostname" {
  description = "local name of the VM"
  type = "string"
  #default     = "terraformtest"
}




variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
 default     = "RHEL"
}


variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image.Note, need to provide is_windows_image = true for windows custom images."
  default     = ""
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based. Only used in conjunction with vm_os_id"
  default     = ""
}                                                               

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}



variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "latest"
}








variable "nb_public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  default     = "0"
}

variable "delete_os_disk_on_termination" {
  description = "Delete datadisk when machine is terminated"
  default     = "false"
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type eg: Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS "
  default     = "Premium_LRS"
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  default     = "1023"
}

variable "data_disk" {
  type        = "string"
  description = "Set to true or false to add a datadisk."
  default     = "true"
}



variable "data_disk_type" {
  description = "Type of data disk eg: Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS "
  default     = "Premium_LRS"
}




variable "boot_diagnostics" {
  description = "(Optional) Enable or Disable boot diagnostics"
  default     = "true"
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics"
  default     = "Standard_LRS"
}

variable "enable_accelerated_networking" {
  type        = "string"
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = "false"
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM.  Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub"
  default     = "~/.ssh/authorized_keys"
}


variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created.westus "
  default = "westus"
    
}


variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created uw1_dev_arwver_infrastructure "
  default     = "uw1_dev_arwver_infrastructure"
}


#variable "node_count" {
  #default = 3
#} 













