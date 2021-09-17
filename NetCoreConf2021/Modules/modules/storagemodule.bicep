param uniqueStorageName string
param isDevEnviorment bool
param locations array

resource jrrnstorage 'Microsoft.Storage/storageAccounts@2019-04-01' = [for location in locations: {
  name: '${uniqueStorageName}${location}'
  location: location
  sku: {
    name: ((isDevEnviorment) ? 'Standard_LRS' : 'Standard_GZRS')
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: ((isDevEnviorment) ? false : true)
  }
}] 

