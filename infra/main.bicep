param location string = resourceGroup().location

@description('Globally unique name for the Web App')
param webAppName string

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Globally unique name for API Management')
param apimName string

@description('Publisher email for API Management')
param publisherEmail string

@description('Publisher name for API Management')
param publisherName string = 'Demo Publisher'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    capacity: 1
  }
  kind: 'app'
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      netFrameworkVersion: 'v8.0'
      use32BitWorkerProcess: true
    }
  }
}

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output webAppNameOut string = webApp.name
output webAppDefaultHostName string = webApp.properties.defaultHostName
output appServicePlanNameOut string = appServicePlan.name
output apimServiceName string = apim.name