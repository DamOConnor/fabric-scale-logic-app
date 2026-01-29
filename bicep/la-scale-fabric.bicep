//param workflows_la_scale_fabgenerakuks_name string = 'la-scale-fabgenerakuks'
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

@description('The Logic App name (based on the Fabric Capacity name)')
param logicAppName string


resource logicApp  'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {
              hours: [
                '21'
              ]
            }
            timeZone: 'GMT Standard Time'
          }
          evaluatedRecurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {
              hours: [
                '21'
              ]
            }
            timeZone: 'GMT Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        HTTP_Scale_Fabric_Capacity: {
          runAfter: {}
          type: 'Http'
          inputs: {
            uri: 'https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Fabric/capacities/${fabricCapacityName}?api-version=2023-11-01'
            method: 'PATCH'
            body: {
              sku: {
                name: sku
                tier: 'Fabric'
              }
            }
            authentication: {
              type: 'ManagedServiceIdentity'
              audience: 'https://management.azure.com'
            }
          }
          runtimeConfiguration: {
            contentTransfer: {
              transferMode: 'Chunked'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {}
      }
    }
  }
}

// Output the Logic App's principal ID so that it can be used for role assignments.
output logicAppPrincipalId string = logicApp.identity.principalId

// Get the fabric capacity resource ID.
output fabricCapacityResourceId string = resourceId(resourceGroupName, 'Microsoft.Fabric/capacities', fabricCapacityName)

// Grant the Logic App's managed identity Contributor access to the Resource Group.
var contributorRoleId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

resource resourceGroupRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(logicApp.id, resourceGroupName, contributorRoleId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contributorRoleId)
    principalId: logicApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
