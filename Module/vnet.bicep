
param vnetName string
param tags object
param location string = resourceGroup().location
param addressPrefix string 
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
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
      }
    }]
  }
}
