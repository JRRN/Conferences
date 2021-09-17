using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Infraestructure.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum TimeFrameEnum
    {
        today,
        tomorrow,
        yesterday
    }
}