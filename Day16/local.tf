locals {

  vnet_department = {
      "vnet_finance" = {
        name= var.tags.finance
        address_space = ["10.1.0.0/16"]
      }
      "vnet_devops" = {
        name= var.tags.devops
        address_space = ["10.2.0.0/16"]
      }
  }

  nic_finance= {
    "nic_vm1_finance" = {
      "name" = var.vm_name.vm1
      "subnet_id" = azurerm_subnet.subnet_finance.id
    }
    "nic_vm2_finance" = {
      "name" = var.vm_name.vm2
      "subnet_id" = azurerm_subnet.subnet_finance.id
    }
  }

  nic_devops= {
    "nic_vm1_devops" = {
      "name" = var.vm_name.vm1
      "subnet_id" = azurerm_subnet.subnet_devops.id
    }
    "nic_vm2_devops" = {
      "name" = var.vm_name.vm2
      "subnet_id" = azurerm_subnet.subnet_devops.id
    }
  }

  vm_instance ={
    "vm1_finance" ={
      name = "${var.tags.finance}-${var.vm_name.vm1}"
      network_interface_ids = [azurerm_network_interface.nic_finance_vm["nic_vm1_finance"].id]
      os_disk_name = "${var.tags.finance}-${var.vm_name.vm1}-os_disk"
    }

    "vm2_finance" ={
      name = "${var.tags.finance}-${var.vm_name.vm2}"
      network_interface_ids = [azurerm_network_interface.nic_finance_vm["nic_vm2_finance"].id]
      os_disk_name = "${var.tags.finance}-${var.vm_name.vm2}-os_disk"
    }

    "vm1_devops" ={
      name = "${var.tags.devops}-${var.vm_name.vm1}"
      network_interface_ids = [azurerm_network_interface.nic_devops_vm["nic_vm1_devops"].id]
      os_disk_name = "${var.tags.devops}-${var.vm_name.vm1}-os_disk"
    }

    "vm2_devops" ={
      name = "${var.tags.devops}-${var.vm_name.vm2}"
      network_interface_ids = [azurerm_network_interface.nic_devops_vm["nic_vm2_devops"].id]
      os_disk_name = "${var.tags.devops}-${var.vm_name.vm2}-os_disk"
    }

  }
}