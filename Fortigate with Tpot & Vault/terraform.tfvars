#Default Location
location="eastus2"

#Lab Suffix
rg-name="nimo"

#Vault Name / same as suffix
name = "nimo"

#FGT user
fgt-user = "fgtadmin"

#FGT SSH Port
ssh_port = "64101"

#FGT HTTPS Port
https_port = "64100"

#Fixed tenant varibales - optional
#tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
#ad_object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"

kv-full-object-id =""
kv-read-object-id =""
kv-secrets = {
    sqldb = {
      value = "" # set to "" will auto-generate the password
    }
    webadmin = {    #Tpot webadmin
      value = ""
    }
    fgtadmin = {     #Fortigate admin
      value = ""
    }
    tpot-admin = {   #Tpot root
      value = ""
    }
  }