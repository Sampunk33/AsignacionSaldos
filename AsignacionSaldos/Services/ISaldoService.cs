using System.Collections.Generic;
using System.Threading.Tasks;
using AsignacionSaldos.Model;

namespace AsignacionSaldos.Services
{
    public interface ISaldoService
    {
        Task<List<AsignacionSaldo>> AsignarSaldosAsync();
    }
}

