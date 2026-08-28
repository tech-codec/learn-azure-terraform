variable "vm_size" {
  type = string
  default = "Standard_D2s_v3"
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

variable "tags" {
  type = map(string)
  default = {
    finance = "finance"
    devops  = "devops"
  }
}

variable "vm_name" {
  type = map(string)
  default = {
    "vm1" = "vm1"
    "vm2" = "vm2"
  }
}