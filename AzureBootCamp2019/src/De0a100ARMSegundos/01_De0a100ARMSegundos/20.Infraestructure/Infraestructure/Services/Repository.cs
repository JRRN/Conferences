using System;
using System.Threading.Tasks;
using Infraestructure.Data.Models;

namespace Infraestructure.Services
{
    public class Repository : IRepository
    {
        private readonly ConferenceContext _context;

        public Repository(ConferenceContext context)
        {
            _context = context;
        }

        public async Task Add(UserConference user)
        {
            try
            {
                using (_context)
                {
                    await _context.UserConferences.AddAsync(user);
                    await _context.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}