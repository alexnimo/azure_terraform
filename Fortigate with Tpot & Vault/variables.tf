
#######################
# General variables #
#######################

variable "rg-name" {
  type = string
  description = "SE name to be used across the lab"
}

variable "location" {
    type = string
    description = "Default Azure location of all resources"
    default = "eastus2"
}

variable "ad_object_id" {

      type        = string
      description = "Service principal ID - allows the creation of azure key vault"
      default =""
}

variable "tenant_id" {

      type        = string
      description = "Azure Tenant ID"
      default =""
}




#######################
# Tpot variables      #
#######################

variable "admin_password" {
  type = string
  description = "vault generated password"
  default = ""
}

variable "webadmin_pass" {
    type = string
    description = "tpot webadmin"
    default = ""
}

#######################
# Netwrok variables   #
#######################

variable "vnet" {
  description = ""
  default     = "172.16.136.0/22"
}

variable "subnet" {
  type        = map(string)
  description = ""

  default = {
    "1" = "172.16.136.0/26"  # External
    "2" = "172.16.136.64/26" # Internal
    "3" = "172.16.137.0/24"  # Protected a - Tpot / Honepot
    "4" = "172.16.138.0/24"  # Protected b - MGMT Net
  }
}

variable "subnetmask" {
  type        = map(string)
  description = ""

  default = {
    "1" = "26" # External
    "2" = "26" # Internal
    "3" = "24" # Protected a - Tpot / Honepot
    "4" = "24" # Protected b - MGMT Net
  }
}

variable "fgt_ipaddress" {
  type        = map(string)
  description = ""

  default = {
    "1" = "172.16.136.5"  # External
    "2" = "172.16.136.70" # Internal
  }
}

variable "gateway_ipaddress" {
  type        = map(string)
  description = ""

  default = {
    "1" = "172.16.136.1"        # External
    "2" = "172.16.136.65"       # Internal
    "4" = "172.16.136.193"      # MGMT
  }
}

#######################
# Fortigate variables #
#######################

#License Type#

variable "FGT_IMAGE_SKU" {
  description = "Azure Marketplace default image sku hourly (PAYG 'fortinet_fg-vm_payg_20190624') or byol (Bring your own license 'fortinet_fg-vm')"
  default     = "fortinet_fg-vm"
}

variable "FGT_VERSION" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
  default     = "latest"
}

variable "FGT_BYOL_LICENSE_FILE" {
  default = "fortigate.lic"
}

variable "fgt_vmsize" {
  default = "Standard_F2s"
}

variable "fgt-user" {
  description = "FGT user"
  default = "fgtadmin"
}

variable "FGT_SSH_PUBLIC_KEY_FILE" {
  default = ""
}

variable "https_port" {
  description = "gui access port"
  default = ""
}

variable "ssh_port" {
  description = "ssh access port"
  default = ""
}


##############################################################################################################
# Accelerated Networking
# Only supported on specific VM series and CPU count: D/DSv2, D/DSv3, E/ESv3, F/FS, FSv2, and Ms/Mms
# https://azure.microsoft.com/en-us/blog/maximize-your-vm-s-performance-with-accelerated-networking-now-generally-available-for-both-windows-and-linux/
##############################################################################################################
variable "FGT_ACCELERATED_NETWORKING" {
  description = "Enables Accelerated Networking for the network interfaces of the FortiGate"
  default     = "true"
}


#######################
# Key Vault variables #
#######################

variable "name" {
  type = string
  description = "vault name"
}

variable "kv-full-object-id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for FULL access to the Azure Key Vault"
  default     = ""
}

variable "kv-read-object-id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for READ access to the Azure Key Vault"
  default     = ""
}

variable "kv-vm-deployment" {
  type        = string
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
  default     = "true"
}

variable "kv-disk-encryption" {
  type        = string
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys" 
  default     = "true"
}

variable "kv-template-deployment" {
  type        = string
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = "true"
}

variable "kv-key-permissions-full" {
  type        = list(string)
  description = "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default     = [ "backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", 
                  "recover", "restore", "sign", "unwrapKey","update", "verify", "wrapKey" ]
}

variable "kv-secret-permissions-full" {
  type        = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default     = [ "backup", "delete", "get", "list", "purge", "recover", "restore", "set" ]
} 

variable "kv-certificate-permissions-full" {
  type        = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default     = [ "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", 
                  "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore" ]
}

variable "kv-storage-permissions-full" {
  type        = list(string)
  description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default     = [ "backup", "delete", "deletesas", "get", "getsas", "list", "listsas", 
                  "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update" ]
}

variable "kv-key-permissions-read" {
  type        = list(string)
  description = "List of read key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default     = [ "get", "list" ]
}

variable "kv-secret-permissions-read" {
  type        = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default     = [ "get", "list" ]
} 

variable "kv-certificate-permissions-read" {
  type        = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default     = [ "get", "getissuers", "list", "listissuers" ]
}

variable "kv-storage-permissions-read" {
  type        = list(string)
  description = "List of read storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default     = [ "get", "getsas", "list", "listsas" ]
}

variable "kv-secrets" {
  type = map(object({
    value = string
  }))
  description = "Define Azure Key Vault secrets"
  default     = {}
}