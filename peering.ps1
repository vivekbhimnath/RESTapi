$token=(Get-AzAccessToken).Token
$rg1Name="vnet1-rg"
$rg2Name="vnet2-rg"
$subscriptionId=(Get-AzSubscription).Id
$vnetprefix="samplevnet"
$vnetpeeringprefix="vnetpeering"


$headers=@{
    authorization="Bearer $token"
    host='management.azure.com'
}

$param_for_vnet1=@{
    uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg1Name/providers/Microsoft.Network/virtualNetworks/${vnetprefix}01?api-version=2021-08-01"
    Method="PUT"
    ContentType='application/json'
    body='{
        "location": "Central US",
        "properties":{
            "addressSpace":{
                "addressprefixes":["10.1.0.0/16"]
            }
        }
    }'
}
Invoke-RestMethod -Headers $headers @param_for_vnet1


$param_for_vnet2=@{
    uri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg2Name/providers/Microsoft.Network/virtualNetworks/${vnetprefix}02?api-version=2021-08-01"
    Method="PUT"
    ContentType='application/json'
    body='{
        "location": "West US",
        "properties":{
            "addressSpace":{
                "addressprefixes":["10.2.0.0/16"]
            }
        }
    }'
}

Invoke-RestMethod -Headers $headers @param_for_vnet2

$param_for_peering1=@{
    uri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg1Name/providers/Microsoft.Network/virtualNetworks/${vnetprefix}01/virtualNetworkPeerings/${vnetpeeringprefix}1to2?api-version=2021-08-01"
    Method="PUT"
    ContentType='application/json'
    Body='{
        "properties":{
            "allowvirtualnetworkaccess": "true",
            "allowforwardedtraffic": "true",
            "allowgatewaytransit": "false",
            "useRemoteGateways": "false",
            "remotevirtualnetwork":{
                "id": "/subscriptions/0b9c4dfd-d9ca-477a-b279-897de40f2d08/resourceGroups/vnet2-rg/providers/Microsoft.Network/virtualNetworks/samplevnet02"
            },
            "remoteAddressSpace":{
                "addressPrefixes":["10.2.0.0/16"]

            },
            "remoteVirtualNetworkAddressSpace":{
                "addressprefixes":["10.2.0.0/16"]
            }

        }

    }'
}

Invoke-RestMethod -Headers $headers @param_for_peering1



$param_for_peering2=@{
    uri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$rg2Name/providers/Microsoft.Network/virtualNetworks/${vnetprefix}02/virtualNetworkPeerings/${vnetpeeringprefix}2to1?api-version=2021-08-01"
    Method="PUT"
    ContentType='application/json'
    Body='{
        "properties":{
            "allowvirtualnetworkaccess": "true",
            "allowforwardedtraffic": "true",
            "allowgatewaytransit": "false",
            "useRemoteGateways": "false",
            "remotevirtualnetwork":{
                "id": "/subscriptions/0b9c4dfd-d9ca-477a-b279-897de40f2d08/resourceGroups/vnet1-rg/providers/Microsoft.Network/virtualNetworks/samplevnet01"
            },
            "remoteAddressSpace":{
                "addressPrefixes":["10.1.0.0/16"]

            },
            "remoteVirtualNetworkAddressSpace":{
                "addressprefixes":["10.1.0.0/16"]
            }

        }

    }'
}

Invoke-RestMethod -Headers $headers @param_for_peering2