using Microsoft.EntityFrameworkCore;

namespace AsignacionSaldos.Context
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        // Aquí puedes agregar DbSets para tus entidades si es necesario.
    }
}
