using Infraestructure.Data.Models;
using Infraestructure.Services;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Repository.Configuration;
using System;

namespace Repository
{
    public static class Repository
    {
        private static IServiceProvider services;
        static Repository()
        {
            services = new ServiceProviderBuilder().Build();
        }

        [FunctionName("Repository")]
        public static void Run([ServiceBusTrigger("queuerepository", Connection = "ServiceBusConnection")]string myQueueItem,
            ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");

            var userConference = JsonConvert.DeserializeObject<UserConference>(myQueueItem);

            using (var scope = services.CreateScope())
            {
                var repository = scope.ServiceProvider.GetRequiredService<IRepository>();
                repository.Add(userConference).GetAwaiter().GetResult();
            }
        }
    }
}
