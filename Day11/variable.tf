variable "project_name" {
  description = "value of resource groupe"
  type = string
  default = "Project ALPHA Resource"
}

variable "Default_tags" {
  description = "Default_tags"
  type = map(string)
  default = {
    "company"    = "TechCorp"
    "managed_by" = "terraform"
  }

}


variable "Environment_tags" {
  description = "Environment tags"
  type = map(string)
  default = {
    environment  = "production"
    cost_center = "cc-123"
  }

}

variable "storage_name" {
  type = string
  default = "pro!j @ ectal?@phastorageaccount"
}

variable "allowed_port" {
  type = string
  default = "80,443,3306"
}


variable "environment" {
  type = string
  description = "environment name"
  default = "dev"
  validation {
    condition = contains(["dev", "staging","prod"], var.environment)
    error_message = "enter the valide value for env:"
  }
}

variable "vm_size_val" {
  type = map(string)
  default = {
    Valid:    "standard_D2s_v3"
    Invalid:  "basic_A0"
    Invalid:  "standard_D2s_v3_extra_long_name"
  }
  
}

variable "vm_size" {
  type = string
  default = "standard_D2s_v3"
  validation {
    condition = (
      length(var.vm_size) >= 2 &&
      length(var.vm_size) <= 20
    )
    error_message = "the lenght of vm size should be between 2 and 20"
  }
  validation {
    condition = (
      strcontains(var.vm_size, "standard")
    )
    error_message = "vm size shoul contain standard"
  }
}

variable "backup_name" {
  type = string
  default = "daily_backup"
  validation {
    condition = endswith(var.backup_name, "_backup")
    error_message = "the backup name must have _backup at the end"
  }
}

variable "credential" {
  type = string
  default = "xyz123"
  sensitive = true
}


variable "validate_path" {
  type = string
  default = "./configs/main.tf"
  validation {
    condition = fileexists(var.validate_path)
    error_message = "the ${split("/",var.validate_path)[length(split("/",var.validate_path)) - 1]} file doesn't exit in ${dirname(var.validate_path)} directory"
  }
}



