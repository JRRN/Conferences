using System;

namespace Storage.Configuration
{
    public interface IServiceProviderBuilder
    {
        IServiceProvider Build();
    }
}