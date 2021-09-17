param baseName string 
param parentName string
param resourceGroup string

resource database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${baseName}-Database'
  location: resourceGroup().location
  parent: sqlServer
}

output database string = database.id

