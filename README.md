# azure_terraform
azure terraform labs

Get tenant and current user id
export TF_VAR_object_id=$(az ad signed-in-user show |jq -r '.objectId')
export TF_VAR_tenant_id=$(az account show --output json | jq -r '.tenantId')

