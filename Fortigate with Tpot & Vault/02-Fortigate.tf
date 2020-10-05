#Read Fortigate vault passwords 
data "azurerm_key_vault" "fgt" {

    name = "${var.name}-keyvault"
    resource_group_name = azurerm_resource_group.rg.name

    depends_on =[
      module.keyvault
    ]
}

data "azurerm_key_vault_secret" "fgt-secret" {

    name = "fgtadmin"
    key_vault_id = data.azurerm_key_vault.fgt.id

    depends_on = [

      data.azurerm_key_vault.fgt
    ]
}

#NSG

resource "azurerm_network_security_group" "fgtnsg" {
  name                = "${var.rg-name}-FGT-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "fgtallowallout" {
  name                        = "Allow_All_Outbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.fgtnsg.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "fgtnsgallowallin" {
  name                        = "Allow_All_Inbound"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.fgtnsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# IP & Interface

resource "azurerm_public_ip" "publicip" {
    name                         = "${var.rg-name}-PublicIP"
    location                     =  var.location
    resource_group_name          =  azurerm_resource_group.rg.name
    allocation_method            = "Dynamic"
    domain_name_label       =  "${var.name}-lab"

    tags = {
        environment = "${var.name}-Tpot Lab"
    }
}

resource "azurerm_network_interface" "fgtaifcext" {
  name                          = "${var.rg-name}-FGT-IFC-EXT"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.FGT_ACCELERATED_NETWORKING

  ip_configuration {
    name                          = "interface1"
    subnet_id                     = azurerm_subnet.subnet-ext.id
    private_ip_address_allocation = "static"
    private_ip_address            = var.fgt_ipaddress["1"]
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "fgtaifcextnsg" {
  network_interface_id      = azurerm_network_interface.fgtaifcext.id
  network_security_group_id = azurerm_network_security_group.fgtnsg.id
}

resource "azurerm_network_interface" "fgtaifcint" {
  name                 = "${var.rg-name}-FGT-IFC-INT"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "interface1"
    subnet_id                     = azurerm_subnet.subnet-int.id
    private_ip_address_allocation = "static"
    private_ip_address            = var.fgt_ipaddress["2"]
  }
}

resource "azurerm_network_interface_security_group_association" "fgtaifcintnsg" {
  network_interface_id      = azurerm_network_interface.fgtaifcint.id
  network_security_group_id = azurerm_network_security_group.fgtnsg.id
}

resource "azurerm_virtual_machine" "fgtvm" {
  name                         = "${var.rg-name}-FGT"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  network_interface_ids        = [azurerm_network_interface.fgtaifcext.id, azurerm_network_interface.fgtaifcint.id]
  primary_network_interface_id = azurerm_network_interface.fgtaifcext.id
  vm_size                      = var.fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = var.FGT_IMAGE_SKU
    version   = var.FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
    name      = var.FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "${var.rg-name}-FGT-OSDISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.rg-name}-FGT"
    admin_username = var.fgt-user
    admin_password = data.azurerm_key_vault_secret.fgt-secret.value
    custom_data    = base64encode(data.template_file.fgt_a_custom_data.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  
  timeouts { 
    create = "8m"
  }

  tags = {
    environment = "${var.rg-name}-SE-LAB"
    vendor      = "Fortinet"
  }
}

data "template_file" "fgt_a_custom_data" {
  template = file("${path.module}/customdata.tpl")

  vars = {
    fgt_vm_name         = "${var.rg-name}-FGT"
    fgt_license_file    = var.FGT_BYOL_LICENSE_FILE
    fgt_username        = var.fgt-user
    fgt_ssh_public_key  = var.FGT_SSH_PUBLIC_KEY_FILE
    fgt_external_ipaddr = var.fgt_ipaddress["1"]
    fgt_external_mask   = var.subnetmask["1"]
    fgt_external_gw     = var.gateway_ipaddress["1"]
    fgt_internal_ipaddr = var.fgt_ipaddress["2"]
    fgt_internal_mask   = var.subnetmask["2"]
    fgt_internal_gw     = var.gateway_ipaddress["2"]
    fgt_protected_net   = var.subnet["3"]
    vnet_network        = var.vnet
    ssh_port            = var.ssh_port
    https_port          = var.https_port
  }
}
