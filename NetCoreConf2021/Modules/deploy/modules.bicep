
param baseName string
param georeplications array
param needRedundancy bool 

module storageModule '../modules/storagemodule.bicep' =  {
  name: baseName
  params: {
     locations: georeplications
     isDevEnviorment: needRedundancy
     uniqueStorageName: baseName
  }
}


