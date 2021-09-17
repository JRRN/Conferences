@minLength(4)
@description('BaseName Prefix')
param baseName string = 'jrrn'

@allowed([
  'dev'
  'int'
  'pro'
])
param enviorment string

@secure()
param sqlPassword string
@secure()
param sqluser string

@minLength(1)
param dbs array

var enviromentNamme = '${baseName}-${enviorment}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: replace('${enviromentNamme}-storage', '-', '') 
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

resource otheraccount 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageaccount.name}/default/${baseName}blobcontainer'
}



resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' ={
  name: '${enviromentNamme}-sqlServer'
  location: resourceGroup().location
  properties:  {
    administratorLogin: sqluser
    administratorLoginPassword: sqlPassword 
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' =[for dbName in dbs: {
  parent: sqlServer
  name: '${enviromentNamme}-${dbName}-db'
  location: resourceGroup().location
}]

output blobStorageConnectionString string = storageaccount.properties.primaryEndpoints.blob

output outputdbs array = [for (dbName, i) in dbs: {
  name: '${enviromentNamme}-${sqlServerDatabase[i].name}-db' 
  connectionString: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${enviromentNamme}-${sqlServerDatabase[i].name}-db;User Id=${sqluser}@${sqlServer};Password=${sqlPassword};' 
}]
