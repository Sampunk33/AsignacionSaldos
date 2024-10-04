using AsignacionSaldos.Context;
using AsignacionSaldos.Services;
using Microsoft.EntityFrameworkCore;

namespace AsignacionSaldos
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseSqlServer("Server=LAPTOP-5D0CAUCT\\MSSQL;Database=Gestores;Trusted_Connection=True;Encrypt=False;"
);

            var context = new ApplicationDbContext(optionsBuilder.Options);
            var saldoService = new SaldoService(context);

            var resultados = await saldoService.AsignarSaldosAsync();

            foreach (var resultado in resultados)
            {
                Console.WriteLine($"Gestor ID: {resultado.GestorId}, Saldo: {resultado.Saldo}");
            }
        }
    }
}
