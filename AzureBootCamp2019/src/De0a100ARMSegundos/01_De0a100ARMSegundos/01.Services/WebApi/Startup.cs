using Infraestructure.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Refit;
using System;
using Infraestructure.Data.Models;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Swagger;
using WebApi.Configuration;
using WebApi.Services;

namespace WebApi
{
    public class Startup
    {
        ConnectionStrings connections = new ConnectionStrings();
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var settings = new RefitSettings();

            services.Configure<ConnectionStrings>(options =>
            {
                options.DefaultConnection = Configuration.GetConnectionString("DefaultConnection");
                options.ServiceBusConnection = Configuration.GetConnectionString("ServiceBusConnection");
            });

            services.AddSwaggerGen(c =>
            {
                c.DescribeAllEnumsAsStrings();
                c.DescribeStringEnumsInCamelCase();
                c.SwaggerDoc("v1", new Info { Title = "De0a100ARMSegundos", Version = "v1" });
            });

            services.AddDbContext<ConferenceContext>(options =>
                options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));

            services.AddScoped<IQueueService, QueueService>();
            
            services.AddRefitClient<IHoroscopeGateway>(settings)
                .ConfigureHttpClient(configuration =>
                {
                    configuration.BaseAddress = new Uri("https://aztro.sameerkumar.website");
                    configuration.Timeout = TimeSpan.FromSeconds(2);
                    
                });
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ConferenceContext context)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath);

            if (env.IsDevelopment())
            {
                builder = builder.AddJsonFile("appsettings.development.json", optional: true, reloadOnChange: true);
            }
            else
            {
                builder = builder.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            }
                
            context.Database.Migrate();
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseSwagger();

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "De0a100ARMSegundos");
                c.RoutePrefix = string.Empty;
            });
            app.UseMvc();
        }
    }
}
