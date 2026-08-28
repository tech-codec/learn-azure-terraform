variable "environment"{
  type = string
  description = "Deployment environment name"
  default = "dev"
}

variable "storage_disk"{
  type = number
  description = "Storage disk size in GB"
  default = 80
}

variable "is_delete" {
  type = bool
  description = "Flag to determine if the OS disk should be deleted on termination"
  default = true
}

variable "allowed_locations" {
  type = list(string)
  description = "List of allowed Azure locations for resource deployment"
  default = ["Canada Central", "East US", "West Europe"]
}

variable "resource_tags" {
  type = map(string)
  description = "Tags to apply to resources"
  default = {
    environment = "Staging"
    managed_by  = "Terraform"
    department  = "Devops"
  }
  
}

variable "network_config" {
  type = tuple([ string, string, number ])
  default = ["10.0.0.0/16", "10.0.2.0", 24]
}

variable "allowed_vm_size" {
  type = list(string)
  default = ["Standard_D2s_v3", "Standard_D4s_v3"]
}

# Object type
variable "vm_config" {
  type = object({
    size         = string
    publisher    = string
    offer        = string
    sku          = string
    version      = string
  })
  description = "Virtual machine configuration"
  default = {
    size         = "Standard_DS1_v2"
    publisher    = "Canonical"
    offer        = "0001-com-ubuntu-server-jammy"
    sku          = "22_04-lts"
    version      = "latest"
  }
}

variable "storage_account_name" {
  type= string
  description = "Name of the storage account"
  default = "techtutorials11"
}