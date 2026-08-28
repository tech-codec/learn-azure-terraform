# create and azure vmss
resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "${var.resource_name_prefix}-vmss"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = lookup(var.vm_size, var.environment_name, "Standard_B2ms")
  instances           = 1
  admin_username      = "adminuser"

  # Every new VMSS instance should automatically execute this shell script
  custom_data = base64encode(file("user-data.sh"))

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/demo_key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.resource_name_prefix}-terraformnetworkprofile"
    primary = true

    ip_configuration {
      name      = "${var.resource_name_prefix}-TestIPConfiguration"
      primary   = true
      subnet_id = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }
}