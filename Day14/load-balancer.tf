resource "random_pet" "lb_hostname" {
}

# CREATE public ip
resource "azurerm_public_ip" "example" {
  name                = "${var.resource_name_prefix}-PI"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  domain_name_label   = "${azurerm_resource_group.example.name}-${random_pet.lb_hostname.id}"

  tags = local.Common_tags
}


# CREATE LOAD BANLANCER WITH NAT POOL, BACKEND POOL
resource "azurerm_lb" "example" {
  name                = "${var.resource_name_prefix}-lb-test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "${var.resource_name_prefix}-LB-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "${var.resource_name_prefix}-BackEndAddressPool"
}

#set up load balancer rule from azurerm_lb.example frontend ip to azurerm_lb_backend_address_pool.bepool backend ip port 80 to port 80
resource "azurerm_lb_rule" "example" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.resource_name_prefix}-LB-PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.example.id
}


#add lb nat rules to allow ssh access to the backend instances
resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.example.name
  name                           = "${var.resource_name_prefix}-ssh"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.resource_name_prefix}-LB-PublicIPAddress"
}

#set up load balancer probe to check if the backend is up
resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "${var.resource_name_prefix}-http-probe"
  protocol        = "Http"
  request_path    = "/"
  port            = 80
}

