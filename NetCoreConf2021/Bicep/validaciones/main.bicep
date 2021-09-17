@description('BaseNamePrefix')
@minLength(5)
@maxLength(10)
@allowed([
  'uno'
  'dos'
  'tres'
])
param baseName string 
