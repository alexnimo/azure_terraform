# Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}    
}

# Create a resource group 
resource "azurerm_resource_group" "main" {
    name     = format("%s-rs-%s",var.prefix,random_id.randomId.hex)
    location = var.specification[var.specification_name]["region"]

    tags = {
        environment = var.specification[var.specification_name]["environment"]
    }
}

# Create storage accouycount - storage name can only consist from lowercase letters
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = lower(format("%sdiagstorage%s",var.prefix,random_id.randomId.hex))
    resource_group_name         = azurerm_resource_group.main.name
    location                    = azurerm_resource_group.main.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = var.specification[var.specification_name]["environment"]
    }
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "securitygroup" {
    name                = format("%s-securitygroup-%s",var.prefix,random_id.randomId.hex)
    location            = var.specification[var.specification_name]["region"]
    resource_group_name = azurerm_resource_group.main.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.specification[var.specification_name]["environment"]
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    # keepers = {
    #     # Generate a new ID only when a new resource group is defined
    #     resource_group = azurerm_resource_group.resourcegroup.name
    # }
    
    byte_length = 2
}



