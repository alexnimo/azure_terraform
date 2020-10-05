output "key-vault-id" {
  description = "Key Vault ID"
  value       = module.keyvault.key-vault-id
}

output "key-vault-url" {
  description = "Key Vault URI"
  value       = module.keyvault.key-vault-url
}

output "key-vault-secrets" {
  description = "Key Vault Secrets"
  value       = module.keyvault.key-vault-secrets
}

output "root-password" {
  description = "root password"
  value = var.admin_password
}