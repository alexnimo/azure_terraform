

#Get Environment variables
data "azurerm_client_config" "current" {}

#create azure-vault


module "keyvault" {
  source              = "../../modules/vault"
  ad_object_id              = data.azurerm_client_config.current.ad_object_id
  tenant_id                 = data.azurerm_client_config.current.client_id
  #ad_object_id               = var.ad_object_id
 # tenant_id                = var.tenant_id
  location            = var.specification[var.specification_name]["region"]
  rg-name           = azurerm_resource_group.main.name
  
  enabled_for_deployment          = var.kv-vm-deployment
  enabled_for_disk_encryption     = var.kv-disk-encryption
  enabled_for_template_deployment = var.kv-template-deployment

  tags = {
    environment = "${var.prefix}"
  }

  policies = {
    full = {
      tenant_id               = var.tenant_id
      object_id               = var.ad_object_id
      key_permissions         = var.kv-key-permissions-full
      secret_permissions      = var.kv-secret-permissions-full
      certificate_permissions = var.kv-certificate-permissions-full
      storage_permissions     = var.kv-storage-permissions-full
    }
  }

  secrets = var.kv-secrets
  prefix = var.prefix

}