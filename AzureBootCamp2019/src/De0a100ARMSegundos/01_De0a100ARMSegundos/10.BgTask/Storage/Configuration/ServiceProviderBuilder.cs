using Infraestructure.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

namespace Storage.Configuration
{
    public class ServiceProviderBuilder : IServiceProviderBuilder
    {
        public IServiceProvider Build()
        {
            //var connectionString = config.GetConnectionStringOrSetting("Values:ConnectionStrings:StorageConnection");

            var services = new ServiceCollection();

            services.AddSingleton<IConfigurationRoot>(options =>
            {
                return new ConfigurationBuilder()
                    .SetBasePath(Environment.CurrentDirectory)
                    .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                    .AddEnvironmentVariables()
                    .Build();
            });
            services.AddScoped<IStorage, Infraestructure.Services.Storage>();
            return services.BuildServiceProvider(true);
        }

    }
}