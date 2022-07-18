targetScope = 'subscription'

param rgName string
param location string = deployment().location
param vnetName string
param subnets array
param tags object
param addressPrefix string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location 
}

module vnet 'Module/vnet.bicep' = {
  scope: rg
  name: 'vnet'
  params: {
    addressPrefix: addressPrefix
    subnets: subnets 
    tags: tags
    vnetName: vnetName 
    location: location
  }
}
