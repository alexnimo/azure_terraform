#Read Tpot vault passwords 
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