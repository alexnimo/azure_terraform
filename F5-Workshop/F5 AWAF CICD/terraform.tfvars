
#Fixed tenant varibales - optional
#tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
#ad_object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"

#Default Location
location="eastus2"

#Default prefix for naming objects
prefix = "nimo-lab"

###############
# Azure Vault #
###############

#Vault policies
kv-full-object-id =""
kv-read-object-id =""

#List of users to create in vault with random passwords
kv-secrets = {
    f5admin = {           # F5 admin
      value = ""          #password value - set to "" (blank password) will auto-generate the password
      length = 20         #maximum password length
      min_upper = 1       #minimum upper case latters
      upper_case = true   #use with the "min_upper" variable to control the minimum upper case characters in the password
      min_lower = 1       #minimum lower case latters
      lower_case = true   #use with the "min_lower" variable to control minimum lower characters in the password
      min_numeric = 2     #minimum numeric values
      numeric     = true  #use with the "min_numeric" variable to control minimum amount of numbers in the password
      min_special = 6     #minimum spcial characters
      special = true      #use with the "min_spcecial" variable to control minimum amount of special characters in the password
    }
    dockeradmin = {    #docker sandbox admin
      value = ""
      length = 18
      min_upper = 5
      upper_case = false
      min_lower = 4
      lower_case = true
      min_numeric = 4
      numeric     = true
      min_special = 5
      special = true
    }
  }

  #########################
  # Network Configuration #
  #########################

  #Vnet

vnets = {
  vnet-main = {        # vnet name
      address_space = "10.0.0.0/8"
      location = ""
  }
  vnet-spoke = {
      address_space   = "10.1.0.0/16"
      location = ""
  }
}

subnets = {
  vnet-main = {
      "external" = "10.0.1.0/24"
      "internal" = "10.0.2.0/24"
      "mgmt"     = "10.0.3.0/24"
  }
  vnet-spoke = {
     "external" = "10.0.1.0/24"
     "internal" = "10.0.2.0/24"
      "mgmt"     = "10.0.3.0/24"
      "web-servers" = "10.0.4.0/24"
  }
}

subnetmask = {
    vnet-main = {
      "external" = "24"
      "internal" = "24"
      "mgmt"     = "28"
  }
  vnet-spoke = {
     "external" = "24"
     "internal" = "24"
      "mgmt"     = "28"
      "web-servers" = "26"
  }
}
  #Subnet

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