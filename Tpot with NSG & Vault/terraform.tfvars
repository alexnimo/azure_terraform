location="eastus2"
rg-name="nimo"
name = "nimo"
#tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
#ad_object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"

kv-full-object-id =""
kv-read-object-id =""
kv-secrets = {
    sqldb = {
      value = "" # set to "" will auto-generate the password
    }
    webadmin = {
      value = ""
    }
    linuxvm = {
      value = ""
    }
    tpot-admin = {
      value = ""
    }
  }