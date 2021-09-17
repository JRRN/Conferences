
variable "allowListValues" {
    description = "Allow List Values"
    type = List
    default = [uno, dos, tres]
}
variable "baseName" {
    type = string
    description = "BaseName Prefix"

    validation  {
     condition = length(var.baseName) > 4 && length(var.baseName) < 11 && contains(allowListValues, baseName)
     error_message = "La variable debe ser mayor a 5 menos 10 y en las lista de parametros permitidios"
    }

    validation  {
     condition = length(var.baseName) > 4 && length(var.baseName) < 11 && contains(allowListValues, baseName)
     error_message = "La variable debe ser mayor a 5 menos 10 y en las lista de parametros permitidios"
    }
}
