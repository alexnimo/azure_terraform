#!/usr/bin/env bash

export TF_VAR_ad_object_id=$(az ad signed-in-user show |jq -r '.objectId')
export TF_VAR_tenant_id=$(az account show --output json | jq -r '.tenantId')

echo "TF_VAR_ad_object_id: $TF_VAR_ad_object_id"
echo "TF_VAR_tenant_id: $TF_VAR_tenant_id"