@description('Name of virtual network')
param vnetName string
@description('address space for virtual network')
param addressPrefix string 
@description('subnet array under virtual network')
param subnets array
param tags object
param location string = resourceGroup().location

var privateDNSZoneNameForWeb = 'privatelink.azurewebsites.net' 
var privateDNSZoneNameForDB = 'privatelink.database.windows.net'


resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' =  {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: [ for subnet in subnets : {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        delegations: (contains(subnet.delegation,'Microsoft.Web/serverFarms'))?[
          {
            name: 'webappdelegation'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }    
          }
        ]:[
          
        ]
      }
    }]
  }
}


resource privateDnsZonesForWeb 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDNSZoneNameForWeb
  location: 'global'
  dependsOn: [
    vnet
  ]
}

resource privateDnsZoneForWebLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZonesForWeb
  name: '${privateDnsZonesForWeb.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource privateDnsZonesForDB 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDNSZoneNameForDB
  location: 'global'
  dependsOn: [
    vnet
  ]
}


resource privateDnsZoneForDBLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZonesForDB
  name: '${privateDnsZonesForDB.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}
