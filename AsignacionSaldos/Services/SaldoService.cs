using AsignacionSaldos.Context;
using AsignacionSaldos.Model;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace AsignacionSaldos.Services
{
    public class SaldoService : ISaldoService
    {
        private readonly ApplicationDbContext _context;

        public SaldoService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<AsignacionSaldo>> AsignarSaldosAsync()
        {
            var result = new List<AsignacionSaldo>();

            var connection = _context.Database.GetDbConnection();
            await connection.OpenAsync();

            using (var command = connection.CreateCommand())
            {
                command.CommandText = "EXEC AsignarSaldos"; // Llama al procedimiento almacenado
                command.CommandType = CommandType.Text;

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        result.Add(new AsignacionSaldo
                        {
                            GestorId = reader.GetInt32(reader.GetOrdinal("GestorId")),
                            Saldo = reader.GetDecimal(reader.GetOrdinal("Saldo"))
                        });
                    }
                }
            }

            return result;
        }
    }
}

