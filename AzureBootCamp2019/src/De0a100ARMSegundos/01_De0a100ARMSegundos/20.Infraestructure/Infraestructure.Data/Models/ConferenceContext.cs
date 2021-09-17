using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Infraestructure.Data.Models
{
    public class ConferenceContext : DbContext
    {
        public ConferenceContext()
        {
        }

        public ConferenceContext(DbContextOptions<ConferenceContext> options)
            : base(options)
        {
        }

        public DbSet<UserConference> UserConferences { get; set; }
    }
}