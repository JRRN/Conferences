using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Infraestructure.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum HoroscopesEnum
    {
        aries,
        taurus,
        gemini, 
        cancer, 
        leo, 
        virgo,
        libra, 
        scorpio, 
        sagittarius, 
        capricorn, 
        aquarius, 
        pisces
    }
}