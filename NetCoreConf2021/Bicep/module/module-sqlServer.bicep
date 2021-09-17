param basePrefix string
param user string
param password string
param databases array

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview'= {
  name: '${basePrefix}-sqlserver'
  location: resourceGroup().location
  properties:  {
    administratorLogin: user
    administratorLoginPassword: password
  }
}

output sqlServerPrefix string = 

resource sqlDb 'Microsoft.Sql/servers/databases@2014-04-01' = [for item in databases: {
  name: '${basePrefix}-${item}-dev'
  parent: sqlServer
  location: resourceGroup().location
}]

