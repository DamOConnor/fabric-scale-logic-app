param workflows_la_scale_fabgenerakuks_name string = 'la-scale-fabgenerakuks'

resource workflows_la_scale_fabgenerakuks_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_la_scale_fabgenerakuks_name
  location: 'uksouth'
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
            uri: 'https://management.azure.com/subscriptions/cf3f51fa-8bf4-45d2-9fe4-edee281ccdb4/resourceGroups/rg-general-uks/providers/Microsoft.Fabric/capacities/fabgeneraluks?api-version=2023-11-01'
            method: 'PATCH'
            body: {
              sku: {
                name: 'F2'
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
