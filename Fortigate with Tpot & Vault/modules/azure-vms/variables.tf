variable "rg-name" {
  type        = string
  description = "The name of an existing Resource Group"
}

variable "location" {
  type        = string
  description = "Define vnet location"
  default = "eastus2"
}

variable "name" {
  type        = string
  description = "The name of the vnet"
  default = "nimo"
}

variable  "tpot_hostname" {

    type     = string
    description  = "tpot uniq hostname"
    default = ""
}

variable "admin_password" {
  type = string
  description = "vault generated password"
  default = ""
}

variable "webadmin_pass" {
    type = string
    description = "tpot webadmin"
    default = ""
}

variable "webadmin" {
    type = string
    description = "tpot webadmin user"
    default = "webadmin"
}

variable "tpot_flavor" {
    type = string
    description = "Specify your tpot flavor [STANDARD, SENSOR, INDUSTRIAL, COLLECTOR, NEXTGEN]"
    default = "STANDARD"
}
