@minLength(3)
@maxLength(11)
param storagePrefix string

param geoReplication bool = false

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string 

@allowed([
  'dev'
  'int'
  'pro'
])
param envirorment string = 'dev'

var uniqueStorageName = '${storagePrefix}${envirorment}'

resource storage 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = storage.properties.primaryEndpoints
