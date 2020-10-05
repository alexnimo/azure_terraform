provider "azurerm" {

 #   version = "2.2.0"
    features{}
  
}

#create resource group


resource "azurerm_resource_group" "rg" {
  
    name = "se-rg-${var.rg-name}"
    location = var.location
    tags = {

        env = "${var.rg-name} terraform lab"
    }
}

##retrive tenant data

#data "azurerm_client_config" "current" {}

#create azure-vault

module "keyvault" {
  source              = "./modules/azure-vault"
  #name                = "${var.environment}-keyvault"
  name                = "${var.name}-keyvault"
  ad_object_id               = var.ad_object_id
  tenant_id                = var.tenant_id
  location            = azurerm_resource_group.rg.location
  rg-name           = azurerm_resource_group.rg.name
  
  enabled_for_deployment          = var.kv-vm-deployment
  enabled_for_disk_encryption     = var.kv-disk-encryption
  enabled_for_template_deployment = var.kv-template-deployment

  tags = {
    environment = "${var.name}"
  }

  policies = {
    full = {
 #     tenant_id               = var.azure-tenant-id
      tenant_id               = var.tenant_id
      object_id               = var.ad_object_id
      key_permissions         = var.kv-key-permissions-full
      secret_permissions      = var.kv-secret-permissions-full
      certificate_permissions = var.kv-certificate-permissions-full
      storage_permissions     = var.kv-storage-permissions-full
    }
  #  read = {
   #   tenant_id               = var.azure-tenant-id
   #   tenant_id               = data.azurerm_client_config.current.client_id
    #  object_id               = var.kv-read-object-id
     # key_permissions         = var.kv-key-permissions-read
      #secret_permissions      = var.kv-secret-permissions-read
      #certificate_permissions = var.kv-certificate-permissions-read
      #storage_permissions     = var.kv-storage-permissions-read
    #}
  }

  secrets = var.kv-secrets
}

data "azurerm_key_vault" "azvault" {

    name = "${var.name}-keyvault"
    resource_group_name = azurerm_resource_group.rg.name

    depends_on =[
      module.keyvault
    ]
}

data "azurerm_key_vault_secret" "vaultsecret" {

    name = "tpot-admin"
    key_vault_id = data.azurerm_key_vault.azvault.id

    depends_on = [

      data.azurerm_key_vault.azvault
    ]
}

data "azurerm_key_vault_secret" "webadmin" {

    name = "webadmin"
    key_vault_id = data.azurerm_key_vault.azvault.id

    depends_on = [

      data.azurerm_key_vault.azvault
    ]
}
#Create Network objects

module "azure-vms" {

    source = "./modules/azure-vms"
    tpot_hostname = "${var.name}-Tpot"
    location = azurerm_resource_group.rg.location
    rg-name = azurerm_resource_group.rg.name
    admin_password = data.azurerm_key_vault_secret.vaultsecret.value
    webadmin_pass = data.azurerm_key_vault_secret.webadmin.value
    
}