using System.Text;
using System.Threading.Tasks;
using Infraestructure.Data.Models;
using Infraestructure.Models;
using Microsoft.Azure.ServiceBus;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using WebApi.Configuration;

namespace WebApi.Services
{
    public class QueueService : IQueueService
    {
        private ConnectionStrings _connectionStrings;
        public QueueService(IOptions<ConnectionStrings> connectionStrings)
        {
            _connectionStrings = connectionStrings.Value;

        }
        public async Task Publish<T>(T message, string queue)
        {
            var result = ParseMessage(message);

            var _client = new QueueClient(_connectionStrings.ServiceBusConnection, queue);

            await _client.SendAsync(result);
            await _client.CloseAsync();
        }

        private Message ParseMessage<T>(T message)
        {
            var json = JsonConvert.SerializeObject(message);
            return new Message(Encoding.UTF8.GetBytes(json));
        }
    }
}