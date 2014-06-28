using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CartaoPontoServer.Models
{
    public class RegistroHora
    {
        public int Id { get; set; }
        public Funcionario Funcionario { get; set; }
        public string DataRegistro { get; set; }
        public string HoraRegistro { get; set; }
        private DateTime DtRegistro { get; set; }


        private void AddDtRegistro(string pDataRegistro, string pHoraRegistro)
        {
            this.DtRegistro = Convert.ToDateTime(pDataRegistro + ' ' + pHoraRegistro);
        }

        public void AddDtRegistro()
        {
            this.DtRegistro = Convert.ToDateTime(this.DataRegistro + ' ' + this.HoraRegistro);
        }

        public DateTime GetDtRegistro()
        {
            return this.DtRegistro;
        }

    }
}