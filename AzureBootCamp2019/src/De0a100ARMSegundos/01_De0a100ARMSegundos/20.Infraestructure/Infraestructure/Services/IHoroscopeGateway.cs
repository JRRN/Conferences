using Infraestructure.Models;
using Refit;
using System.Threading.Tasks;

namespace Infraestructure.Services
{
    public interface IHoroscopeGateway
    {
        [Post("/?sign={sign}&day={timeFrame}")]
        Task<ResultHoroscope> GetHoroscope(string timeFrame, string sign);
    }
}