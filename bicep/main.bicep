// Setup

targetScope = 'subscription'

// Parameters

@description('The location for all resources deployed in this template')
param location string

// Yes these are coupled; could split out
@description('The Resource Group for the Fabric Capacity and Logic App')
param resourceGroupName string  

@description('The name of the Microsoft Fabric capacity resource to update.')
param fabricCapacityName string

@description('The subscription ID where the Fabric capacity exists.')
param subscriptionId string = subscription().subscriptionId

@description('The Fabric F-SKU size, eg F2, F64 etc')
param sku string = 'F2'

// Variables
var logicAppName = 'la-scale-${fabricCapacityName}'


// Resource group

resource rg_res 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}


// Logic App

module logicApp './la-scale-fabric.bicep' = {
  name: 'logicApp'
  scope: resourceGroup(rg_res.name)
  params: {
    location: location
    resourceGroupName: resourceGroupName
    fabricCapacityName: fabricCapacityName
    subscriptionId: subscriptionId
    sku: sku
    logicAppName: logicAppName
  }
  dependsOn: [    
  ]
}

