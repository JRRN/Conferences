
param basePrefix string = 'jrrn'
@secure()
param storageConnectionString string

resource webapp 'Microsoft.Web/sites/functions@2021-01-15' = {
  name: basePrefix
   properties: {
       config: storageConnectionString
   }
}
