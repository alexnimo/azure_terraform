#Default Location
#location="eastus2"

prefix = "nimo-lab"

#Fixed tenant varibales - optional
#tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
#ad_object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"

kv-full-object-id =""
kv-read-object-id =""

#List of users to create with random controlled passwords
kv-secrets = {
    sqldb = {
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
    f5admin = {    #F5 admin
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
    fgtadmin = {     #Fortigate admin
      value = ""
      length = 8
      min_upper = 1
      upper_case = false
      min_lower = 1
      lower_case = true
      min_numeric = 1
      numeric     = true
      min_special = 1
      special = true
    }
    tpot-admin = {   #Tpot root
      value = ""
      length = 16
      min_upper = 2
      upper_case = true
      min_lower = 5
      lower_case = true
      min_numeric = 5
      numeric     = true
      min_special = 0
      special = false
    }
  }