using Newtonsoft.Json;

namespace Infraestructure.Models
{
    public class HoroscopePost
    {
        [JsonRequired]
        public string Sign { get; set; }
        [JsonRequired]
        public string TimeFrame { get; set; }
    }
}