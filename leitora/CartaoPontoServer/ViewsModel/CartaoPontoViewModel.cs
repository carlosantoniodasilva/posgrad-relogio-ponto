using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CartaoPontoServer.ViewsModel
{
    public class CartaoPontoViewModel
    {

        public int IdFuncionario { get; set; }
        public string NomeFuncionario { get; set; }

       [DataType(DataType.Date)]
        public DateTime DtInicio { get; set; }

        
        public DateTime DtFim { get; set; }

    }
}