@minLength(3)
@maxLength(11)
param basePrefix string = 'jrrn'

@minLength(4)
@maxLength(20)
@secure()
param sqlUser string

@minLength(8)
@maxLength(20)
@secure()
param sqlPassword string 

@allowed([])
param allow string

module moduleStorage 'module-storage.bicep' =  {
  name: 'storageDeploy'
  params: {
    location: resourceGroup().location
    storageSKU: 'Premium_LRS'
    storagePrefix: basePrefix    
  }
}

module moduleSQL 'module-sqlServer.bicep' =  {
  name: 'sqlDeploy'
  params: {
    basePrefix: basePrefix
    databases: [
      'uno'
      'dos' 
      'tres'
    ]
    password: sqlPassword
    user: '${basePrefix}${sqlUser}'
  }
}
