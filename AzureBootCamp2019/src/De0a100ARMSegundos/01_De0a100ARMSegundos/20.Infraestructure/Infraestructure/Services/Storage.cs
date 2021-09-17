using System;
using System.Threading.Tasks;
using Infraestructure.Models;
using Microsoft.EntityFrameworkCore.Scaffolding;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;

namespace Infraestructure.Services
{
    public class Storage : IStorage
    {
        private CloudStorageAccount _storageAccount;
        
        public async Task<CloudBlobContainer> CreateBlobStorage(string connection)
        {
            GetStorageAccount(connection);
            CloudBlobClient blobClient = _storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference("0a100armsegundosstorage");
            await container.CreateIfNotExistsAsync();
            return container;
        }

        public async Task UploadContent(CloudBlobContainer container, ResultHoroscope jsonContent)
        {
            CloudBlockBlob blockBlob = container.GetBlockBlobReference($"horoscopes_{DateTime.Now.Day}{DateTime.Now.Millisecond}");
            await blockBlob.UploadTextAsync(JsonConvert.SerializeObject(jsonContent));
        }

        private void GetStorageAccount(string connection)
        {
            _storageAccount =  CloudStorageAccount.Parse(connection);
        }
    }
}