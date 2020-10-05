
###Network Configuration###

resource "azurerm_virtual_network" "vnet-vm" {
  name                = "${var.name}-vm_network"
  resource_group_name = var.rg-name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "honeypot-subnet" {
  name                 = "honeypot-subnet"
  virtual_network_name = azurerm_virtual_network.vnet-vm.name
  resource_group_name  = var.rg-name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "mgmt-net" {
  name                 = "mgmt-net"
  virtual_network_name = azurerm_virtual_network.vnet-vm.name
  resource_group_name  = var.rg-name
  address_prefix       = "10.0.2.0/24"
}



resource "azurerm_network_interface" "tpot-nic" {
  name                = "${var.name}-tpot_nic"
  resource_group_name = var.rg-name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  azurerm_subnet.honeypot-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  azurerm_public_ip.publicip.id
  }
}

resource "azurerm_public_ip" "publicip" {
    name                         = "myPublicIP"
    location                     =  var.location
    resource_group_name          =  var.rg-name
    allocation_method            = "Dynamic"
    domain_name_label       =  "${var.name}-tpot"

    tags = {
        environment = "${var.name}-Tpot Lab"
    }
}

resource "azurerm_subnet_network_security_group_association" "tpot" {
  network_security_group_id            = azurerm_network_security_group.tpot.id
  subnet_id                            = azurerm_subnet.honeypot-subnet.id
}

resource "azurerm_network_interface_security_group_association" "tpot-nic" {
  network_interface_id      = azurerm_network_interface.tpot-nic.id
  network_security_group_id = azurerm_network_security_group.tpot.id
  depends_on = [
      azurerm_public_ip.publicip,
      azurerm_network_security_group.tpot,
  ]
}
### Jump Host ###


###################
###Tpot honeypot###
###################

resource "azurerm_linux_virtual_machine" "tpot" {
  name                            = var.tpot_hostname
  resource_group_name             = var.rg-name
  location                        = var.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "tpot-admin"
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.tpot-nic.id
  ]

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
 
}

#Tpot Intsallation
resource "null_resource" "tpot-install" {

    depends_on = [
        azurerm_linux_virtual_machine.tpot,
        azurerm_public_ip.publicip
    ]

  provisioner "local-exec" {
    #tpot coniguration file creation
    command = <<EOT
    echo '# tpot configuration file' > tpot.conf
    echo 'myCONF_TPOT_FLAVOR="${var.tpot_flavor}"'   >> tpot.conf
    echo 'myCONF_WEB_USER="${var.webadmin}"'   >> tpot.conf
    echo 'myCONF_WEB_PW="${var.webadmin_pass}"' >> tpot.conf
    EOT
  }
  
  #copy tpot.conf to tpot vm
  provisioner "file" {
      connection {
          type = "ssh"
          host = azurerm_public_ip.publicip.fqdn
          user = "tpot-admin"
          password = var.admin_password
      }
      source = "tpot.conf"
      destination = "/home/tpot-admin/tpot.conf"
  }

 #install tpot
  provisioner "remote-exec" {
       connection {
          type = "ssh"
          host = azurerm_public_ip.publicip.fqdn
          user = "tpot-admin"
          password = var.admin_password
      }
      inline = [
          "sleep 15",
          "echo ${var.admin_password} | sudo -S apt update",
          "sudo apt -y install cloud-init",
          "sudo apt upgrade -y",
          "sudo apt install -y git",
          "sudo chown 600 /home/tpot-admin/tpot.conf",
          "sudo chown tpot-admin:tpot-admin /home/tpot-admin/tpot.conf",
          "git clone https://github.com/dtag-dev-sec/tpotce /home/tpot-admin/tpot",
          "sudo /home/tpot-admin/tpot/iso/installer/install.sh --type=auto --conf=/home/tpot-admin/tpot.conf",
          "sudo apt -y autoremove",
          "sudo systemctl reboot"
      ]
  }
}

###NSG for Tpot honeypot####

resource "azurerm_network_security_group" "tpot" {
  name                = "${var.name}-tpot-nsg"
  location            =  var.location
  resource_group_name =  var.rg-name

  security_rule {
    name                       = "honeypot_tcp"
    description                = "Allow honeypot ports tcp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1-64000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "honeypot_udp"
    description                = "Allow honeypot ports udp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "1-64000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "Tpot_admin_web"
    description                = "Allow Tpot admin ui access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "64294"
    source_address_prefix      = "*"    #admin workstation only
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Tpot_ssh"
    description                = "Allow Tpot ssh access"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "64295"
    source_address_prefix      = "*"  #admin workstation only
    destination_address_prefix = "*" 
  }

    security_rule {
    name                       = "Tpot_web_ui"
    description                = "Allow Tpot kibana access"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "64297"
    source_address_prefix      = "*"  #admin workstation only
    destination_address_prefix = "*" 
  }
}

#Log analytics configuration - Sends logs to Sentinel
data "azurerm_log_analytics_workspace" "diag" {
  name                = "se-sentinel-ws"
  resource_group_name = "se-permanent-rs"
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name               = "tpot-nsg-diag"
  target_resource_id = azurerm_network_security_group.tpot.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.diag.id
  depends_on                  = [
     azurerm_network_security_group.tpot
  ]
  
  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days = "30"
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true

    retention_policy {
      enabled = true
      days = "30"
    }
  }

}