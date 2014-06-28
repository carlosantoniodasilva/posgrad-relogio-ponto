using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CartaoPontoServer.Models;
using CartaoPontoServer.Repository;
using CartaoPontoServer.Services;

namespace CartaoPontoServer.Controllers
{
    public class RegistroHoraController : ApiController
    {

        private RegistroHoraRepository repository = new RegistroHoraRepository();
        
        public IEnumerable<RegistroHora> GetAllRegistroHora()
        {
            IEnumerable<RegistroHora> registros = repository.GetAll();

            if (registros != null)
            {
                repository.MarcarComoLidoTodosRegistros();
            }

            return registros;
        }

        public IHttpActionResult GetRegistroPonto(int id)
        {
            var registroPonto = repository.Get(id);
            if (registroPonto == null)
            {
                return NotFound();
            }
            return Ok(registroPonto);
        }

        public IEnumerable<RegistroHora> GetRegistroHoraByFuncionario(string funcionario)
        {

            IEnumerable<RegistroHora> registros = repository.GetAllByFuncionario(Convert.ToInt32(funcionario));

            //marca como lido
            repository.MarcarComoLidoRegistroFuncionario(Convert.ToInt32(funcionario));

            return registros;



        }

    }
}