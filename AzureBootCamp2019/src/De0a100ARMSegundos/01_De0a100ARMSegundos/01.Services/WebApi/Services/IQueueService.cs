using System.Threading.Tasks;
using Infraestructure.Data.Models;
using Infraestructure.Models;

namespace WebApi.Services
{
    public interface IQueueService
    {
        Task Publish<T>(T message, string queue);
    }
}