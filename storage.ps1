$token=(Get-AzAccessToken).Token
$rgName="stg-rest-rg"
$subscriptionId=(Get-AzSubscription).Id
$vnetName="vnet1"
$subnetName="subnet1"
$stgAccName="stgforvivek01"


$param_for_vnet=@{
    uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.Network/virtualNetworks/${vnetName}?api-version=2021-08-01"
    Method='PUT'
    ContentType="application/json"
    headers=@{
        authorization= "Bearer $token"
        host= 'management.azure.com'
        }   

        body='{
            "location":"East US",
            "properties":{
                "addressSpace":{
                    "addressPrefixes":["10.0.0.0/16"]
                }
                
            }
        }'
} 

Invoke-RestMethod @param_for_vnet

$param_for_subnet=@{
    uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/${subnetName}?api-version=2021-08-01"
    Method='PUT'
    ContentType="application/json"
    headers=@{
        authorization="Bearer $token"
        host='management.azure.com'
    }
    body='{
        "properties":{
            "addressPrefix":"10.0.1.0/24"
        }

    }'

}
 Invoke-RestMethod @param_for_subnet

 $param_for_stg=@{
     uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.storage/storageAccounts/${stgAccName}?api-version=2021-09-01"
     Method="PUT"
     ContentType="application/json"
     headers=@{
         authorization="Bearer $token"
         host='management.azure.com'
     }
     body='{
         "location":"East US",
         "properties":{
             "accessTier": "Hot",
             "minimumTlsVersion": "TLS1_2",
             "supportsHttpsTrafficOnly": "true",
             "allowblobpublicAccess":"False",
             "publicNetworkAccess":"disabled",
             "isHnsEnabled": true,
             "isSftpEnabled": true,
             "networkAcls": {
                "bypass": "AzureServices",
                "defaultAction": "Allow",
                "resourceAccessRules":[],
                "ipRules":[],
                "virtualNetworkRules": [
                    {
                        "action": "Allow",
                        "id": "/subscriptions/0b9c4dfd-d9ca-477a-b279-897de40f2d08/resourceGroups/stg-rest-rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1"
                        
                    }
    
                ]  
         }
        },
         "sku": {
            "name": "Standard_LRS"
        },
        "kind": "BlobStorage"
     }' 
    }
    
    Invoke-RestMethod @param_for_stg

