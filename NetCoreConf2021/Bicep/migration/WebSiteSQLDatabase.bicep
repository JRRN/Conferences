@minLength(1)
param hostingPlanName string
param storageAccountsName string = 'de0a100armsegstorage'

@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param skuName string = 'F1'

@description('Describes plan\'s instance count')
@minValue(1)
param skuCapacity int = 1
param administratorLogin string

@secure()
param administratorLoginPassword string
param databaseName string
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@allowed([
  'Basic'
])
param edition string = 'Basic'
param maxSizeBytes string = '1073741824'

@description('Describes the performance level for Edition')
@allowed([
  'Basic'
])
param requestedServiceObjectiveName string = 'Basic'
param serviceBusName string = 'de0a100armsegundosservicebus'
param serviceBusQueueNames array = [
  'queuerepository'
  'queuestorage'
]
param functionNames array = [
  'repository'
  'storage'
]

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Premium_LRS'
])
param de0a100armsegundosstorageType string = 'Standard_LRS'
param de0a100armssegundosfunctionName string = 'de0a100armsegundosfunction'

var webSiteName_var = 'de0a100armsegundosapi'
var sqlserverName_var = 'de0a100armsegundossqlserver'
var servicebusName_var = 'de0a100armsegundosservicebus'
var defaultSASKeyName = 'RootManageSharedAccessKey'
var outputServiceBus = resourceId('Microsoft.ServiceBus/namespaces/authorizationRules', servicebusName_var, defaultSASKeyName)
var de0a100armsegundosstorageName = 'de0a100armsegundosstorage${uniqueString(resourceGroup().id)}'

resource storageAccountsName_resource 'Microsoft.Storage/storageAccounts@2018-07-01' = {
  name: storageAccountsName
  location: 'West Europe'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource sqlserverName 'Microsoft.Sql/servers@2014-04-01-preview' = {
  name: sqlserverName_var
  location: resourceGroup().location
  tags: {
    displayName: 'SqlServer'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlserverName_databaseName 'Microsoft.Sql/servers/databases@2014-04-01-preview' = {
  parent: sqlserverName
  name: '${databaseName}'
  location: resourceGroup().location
  tags: {
    displayName: 'Database'
  }
  properties: {
    edition: edition
    collation: collation
    maxSizeBytes: maxSizeBytes
    requestedServiceObjectiveName: requestedServiceObjectiveName
  }
}

resource sqlserverName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallrules@2014-04-01-preview' = {
  parent: sqlserverName
  location: resourceGroup().location
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource hostingPlanName_resource 'Microsoft.Web/serverfarms@2015-08-01' = {
  name: hostingPlanName
  location: resourceGroup().location
  tags: {
    displayName: 'HostingPlan'
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    name: hostingPlanName
  }
}

resource serviceBusName_resource 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: servicebusName_var
  location: 'West Europe'
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    provisioningState: 'Succeeded'
    metricId: '53889492-cf90-4086-a218-b27ef9ad8caa:${serviceBusName}'
    createdAt: '3/4/2019 12:44:37'
    updatedAt: '3/4/2019 12:45:10'
    serviceBusEndpoint: 'https://${serviceBusName}.servicebus.windows.net:443/'
    status: 'Active'
  }
}

resource ServiceBusName_ServiceBusQueueNames 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = [for item in serviceBusQueueNames: {
  name: '${serviceBusName}/${item}'
  location: 'West Europe'
  properties: {
    deadLetteringOnMessageExpiration: true
    defaultMessageTimeToLive: 'P14D'
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    enableBatchedOperations: true
    enableExpress: false
    enablePartitioning: true
    lockDuration: 'PT30S'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    status: 'Active'
  }
  dependsOn: [
    resourceId('Microsoft.ServiceBus/namespaces', serviceBusName)
  ]
}]

resource webSiteName 'Microsoft.Web/sites@2015-08-01' = {
  name: webSiteName_var
  location: resourceGroup().location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${hostingPlanName}': 'empty'
    displayName: 'Website'
  }
  properties: {
    name: webSiteName_var
    serverFarmId: hostingPlanName_resource.id
  }
}

resource webSiteName_connectionstrings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: webSiteName
  name: 'connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlserverName.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${administratorLogin}@${sqlserverName_var};Password=${administratorLoginPassword};'
      type: 'SQLServer'
    }
    ServiceBusConnection: {
      value: '${outputServiceBus}2017-04-01'
      type: 'Custom'
    }
    StorageConnection: {
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountsName};AccountKey=${listKeys(storageAccountsName_resource.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value}'
      type: 'Custom'
    }
  }
  dependsOn: [
    serviceBusName_resource
  ]
}

resource Microsoft_Insights_components_webSiteName 'Microsoft.Insights/components@2014-04-01' = {
  name: webSiteName_var
  location: 'West Europe'
  tags: {
    'hidden-link:${resourceGroup().id}/providers/Microsoft.Web/sites/${webSiteName_var}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  properties: {
    ApplicationId: webSiteName_var
  }
  dependsOn: [
    webSiteName
  ]
}

resource de0a100armssegundosfunctionName_functionNames 'Microsoft.Web/sites@2016-03-01' = [for item in functionNames: {
  name: concat(de0a100armssegundosfunctionName, item)
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountsName};AccountKey=${listKeys(storageAccountsName_resource.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountsName};AccountKey=${listKeys(storageAccountsName_resource.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(de0a100armssegundosfunctionName)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '10.14.1'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(Microsoft_Insights_components_webSiteName.id, '2014-04-01').InstrumentationKey
        }
        {
          name: 'ServiceBusConnection'
          value: '${outputServiceBus}2017-04-01'
        }
        {
          name: 'Values:ConnectionStrings:StorageConnection'
          value: ((item == 'Storage') ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccountsName};AccountKey=${listKeys(storageAccountsName_resource.id, providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value}' : '')
        }
        {
          name: 'BindingRedirects'
          value: '{ "ShortName": "Newtonsoft.Json", "RedirectToVersion": "11.0.0.0", "PublicKeyToken": "30ad4fe6b2a6aeed" }'
        }
        {
          name: 'Values:ConnectionStrings:DefaultConnection'
          value: ((item == 'Repository') ? 'Data Source=tcp:${sqlserverName.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${administratorLogin}@${sqlserverName_var};Password=${administratorLoginPassword};' : '')
        }
      ]
    }
  }
  dependsOn: [
    storageAccountsName_resource
    serviceBusName_resource
  ]
}]

output serviceBusConnectionString string = listkeys(outputServiceBus, '2017-04-01').primaryConnectionString