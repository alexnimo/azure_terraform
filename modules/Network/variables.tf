
variable "location" {
  type        = string
  description = "Default vent location"
  default = "eastus2"
}

variable "rg-name" {
  type        = string
  description = "The name of an existing Resource Group"
}

variable "prefix" {
  default = ""
}

variable "vnets" {
  type     = map(object({
    address_space = string
    location      = string
  }))
  description = "vnet settings"
  default = {}
}

variable "subnets" {
  type =  map(object({
    subnet = string
    mask = number
  }))
  description = "subnets in each vnet"
  default = {}
}

variable "subnetmask" {
  type =  map(object({}))
  description = "subnet mask in each subnet"
  default = {}
}