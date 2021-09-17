using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Infraestructure.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum GeneroEnum
    {
        noespecificado,
        hombre,
        mujer
    }
}