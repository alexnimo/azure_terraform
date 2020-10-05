# Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}    
}

# Create a resource group 
resource "azurerm_resource_group" "main" {
    name     = format("%s-rs",var.prefix)
    location = var.specification[var.specification_name]["region"]

    tags = {
        environment = var.specification[var.specification_name]["environment"]
    }
}

# Generate random text for suffix randomization
/*resource "random_id" "randomId" {
    # keepers = {
    #     # Generate a new ID only when a new resource group is defined
    #     resource_group = azurerm_resource_group.resourcegroup.name
    # }
    
    byte_length = 2
}
*/









