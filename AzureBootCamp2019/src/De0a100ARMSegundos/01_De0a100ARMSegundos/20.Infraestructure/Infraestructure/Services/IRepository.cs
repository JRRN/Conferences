using System.Threading.Tasks;
using Infraestructure.Data.Models;

namespace Infraestructure.Services
{
    public interface IRepository
    {
        Task Add(UserConference user);
    }
}