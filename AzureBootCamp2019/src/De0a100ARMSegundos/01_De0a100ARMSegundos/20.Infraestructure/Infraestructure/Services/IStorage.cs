using System.Threading.Tasks;
using Infraestructure.Models;
using Microsoft.WindowsAzure.Storage.Blob;

namespace Infraestructure.Services
{
    public interface IStorage
    {
        Task<CloudBlobContainer> CreateBlobStorage(string connection);
        Task UploadContent(CloudBlobContainer container, ResultHoroscope jsonContent);
    }
}