@description('Globally unique name of the App Service.')
@minLength(2)
@maxLength(56)
param appServiceName string

var appServicePlanName = '${appServiceName}-asp'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  kind: 'linux'
  sku: {
    name: 'S1'
  }
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceName
  location: resourceGroup().location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
      linuxFxVersion: 'DOTNETCORE|10.0'
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
    }
  }
}

output appServiceUrl string = 'https://${appService.properties.defaultHostName}'
