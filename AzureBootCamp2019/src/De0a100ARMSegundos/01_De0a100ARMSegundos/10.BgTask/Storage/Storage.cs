using Infraestructure.Models;
using Infraestructure.Services;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Storage.Configuration;
using System;
using Microsoft.Extensions.Configuration;


namespace Storage
{
    public static class Storage
    {
        private static IServiceProvider services;
        static Storage()
        {
            services = new ServiceProviderBuilder().Build();
        } 
        
        [FunctionName("Storage")]
        public static void Run([ServiceBusTrigger("queuestorage", Connection = "ServiceBusConnection")]string myQueueItem, 
            ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");

            var horoscopeResult = JsonConvert.DeserializeObject<ResultHoroscope>(myQueueItem);
            var scope = services.CreateScope();
            var storageService = scope.ServiceProvider.GetService<IStorage>();
            var configuration = scope.ServiceProvider.GetService<IConfigurationRoot>();

            var connection = configuration.GetConnectionStringOrSetting("Values:ConnectionStrings:StorageConnection");

            var container = storageService.CreateBlobStorage(connection).GetAwaiter().GetResult();
            storageService.UploadContent(container, horoscopeResult).GetAwaiter().GetResult();
        }
    }
}
