using System;
using Infraestructure.Data.Models;
using Infraestructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Storage.Configuration;

namespace Repository.Configuration
{
    public class ServiceProviderBuilder : IServiceProviderBuilder
    {
        public IServiceProvider Build()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .SetBasePath(Environment.CurrentDirectory)
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            var connectionString = config.GetConnectionStringOrSetting("Values:ConnectionStrings:DefaultConnection");

            var services = new ServiceCollection();

            services.AddDbContext<ConferenceContext>(
                options => options.UseSqlServer(connectionString))
                .AddSingleton<DbContext>();

            services.AddScoped<IRepository, Infraestructure.Services.Repository>();
            return services.BuildServiceProvider(true);
        }

    }
}