using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CartaoPontoServer.Services
{
    public class RegistroHoraService
    {
        public int Id { get; set; }
        public FuncionarioService Funcionario { get; set; }
        public string DataRegistro { get; set; }
        public string HoraRegistro { get; set; }

    }
}