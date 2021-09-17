using System;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Infraestructure.Data.Models;
using Infraestructure.Models;
using Infraestructure.Services;
using WebApi.Configuration;
using WebApi.Services;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HoroscopeController : ControllerBase
    {
        private readonly IHoroscopeGateway _horoscopeGateway;
        private readonly IQueueService _queueService;
        public HoroscopeController(IHoroscopeGateway horoscopeGateway, IQueueService queueService)
        {
            _horoscopeGateway = horoscopeGateway;
            _queueService = queueService;
        }
        [HttpGet]
        public async Task<OkObjectResult> GetDailyHoroscope(string nombre, int edad, GeneroEnum genero, HoroscopesEnum sign, TimeFrameEnum timeFrame)
        {
            var result = await _horoscopeGateway.GetHoroscope(timeFrame.ToString(), sign.ToString());

            var userConference = new UserConference
            {
                Edad = edad,
                Fecha = DateTime.UtcNow,
                Genero = genero.ToString(),
                Horoscopo = sign.ToString(),
                Nombre = nombre
            };

            await _queueService.Publish<UserConference>(userConference, QueueEnum.queuerepository.ToString());
            await _queueService.Publish<ResultHoroscope>(result, QueueEnum.queuestorage.ToString());

            return Ok(result);
        }
    }
}