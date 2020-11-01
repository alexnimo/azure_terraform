

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = try(format("%s-%s", var.prefix, each.key))
  location            = lookup(each.value, "location") != "" ? lookup(each.value, "location") : var.location
  resource_group_name = var.rg-name
  address_space       = [each.value.address_space]

    dynamic "subnet" {
        for_each = [for k , s in var.subnets: {
            name     = k
            address_prefix   = s.subnet
        }]
        content {
            name = try(subnet.value.name)
            address_prefix = try(subnet.value.address_prefix)
        }
    }
}

/*resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = try(format("%s-%s", var.prefix, each.key))
  location            = lookup(each.value, "location") != "" ? lookup(each.value, "location") : var.location
  resource_group_name = var.rg-name
  address_space       = [each.value.address_space]

    dynamic "subnet" {
        for_each = [for k, s in var.subnets: {
            name     = each.key
            address_prefix   = s.subnet
        }]
        content {
            name = subnet.value.name
            address_prefix = subnet.value.address_prefix
        }
    }
}*/