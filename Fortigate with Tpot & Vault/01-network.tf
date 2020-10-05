resource "azurerm_virtual_network" "vnet" {
  name                = "${var.rg-name}-VNET"
  address_space       = [var.vnet]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet-ext" {
  name                 = "${var.rg-name}-FGT-External"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet["1"]
}

resource "azurerm_subnet" "subnet-int" {
  name                 = "${var.rg-name}-FGT-Internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet["2"]
}

resource "azurerm_subnet" "subnet-tpot" {
  name                 = "${var.rg-name}-Tpot_Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet["3"]
}

resource "azurerm_subnet" "subnet-mgmt" {
  name                 = "${var.rg-name}-mgmt_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet["4"]
}

resource "azurerm_subnet_route_table_association" "subnet5rt" {
  subnet_id      = azurerm_subnet.subnet-tpot.id
  route_table_id = azurerm_route_table.protectedaroute.id

  lifecycle {
    ignore_changes = [route_table_id]
  }
}

resource "azurerm_route_table" "protectedaroute" {
  name                = "${var.rg-name}-RT-PROTECTED-A"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = var.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
  route {
    name           = "Subnet"
    address_prefix = var.subnet["3"]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
}

resource "azurerm_subnet_route_table_association" "subnet6rt" {
  subnet_id      = azurerm_subnet.subnet-mgmt.id
  route_table_id = azurerm_route_table.protectedbroute.id

  lifecycle {
    ignore_changes = [route_table_id]
  }
}

resource "azurerm_route_table" "protectedbroute" {
  name                = "${var.rg-name}-RT-PROTECTED-B"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "VirtualNetwork"
    address_prefix         = var.vnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
  route {
    name           = "Subnet"
    address_prefix = var.subnet["4"]
    next_hop_type  = "VnetLocal"
  }
  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fgt_ipaddress["2"]
  }
}