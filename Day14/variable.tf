variable "vm_size" {
  type = map(string)
  default = {
    Dev= "Standard_B1s"
    Stage= "Standard_B2s"
    Prod = "Standard_D2s_v3"
    # Prod= "Standard_B2ms"
  }
}

variable "environment_name" {
  type = string
  default = "Prod"
}

variable "region" {
  type = string
  default = "Canada Cantral"
}

variable "resource_name_prefix" {
  type = string
  default = "app"
}

variable "instance_counts" {
  type = number
  default = 2
}

variable "network_address_spaces" {
  type = list(string)
  default = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24"]
}