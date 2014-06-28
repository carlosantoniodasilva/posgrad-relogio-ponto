using System;
using System.Collections.Generic;
using CartaoPontoServer.Models;
using CartaoPontoServer.Repository;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CartaoPontoServer.Tests
{
    [TestClass]
    public class RegistroHoraRepositoryTest
    {
        [TestMethod]
        public void RegistroHoraRepository_AddGetAllTest()
        {
            try
            {
                List<RegistroHora> wrkRegistros = CartaoPontoServer.Helpers.RegistroHoraHelper.GerarCartaoPonto(new DateTime(2013, 6, 1), null);

                foreach (RegistroHora wrkRegistro in wrkRegistros)
                {
                    wrkRegistro.Funcionario = new Funcionario() { Id = 1, Nome = "Ademar" };
                }

                RegistroHoraRepository repository = new RegistroHoraRepository();
                repository.Add(wrkRegistros);

                repository.GetAll();

            }
            catch (Exception wrkErroEx)
            {
                string wrkErroStr = wrkErroEx.ToString();
                if (wrkErroStr != null)
                {

                }

            }

        }

        [TestMethod]
        public void RegistroHoraRepository_GetAllTest()
        {
            try
            {
                RegistroHoraRepository repository = new RegistroHoraRepository();
                IEnumerable<RegistroHora> wrkRegistros = repository.GetAll();

                if (wrkRegistros != null)
                {

                }

            }
            catch (Exception wrkErroEx)
            {
                string wrkErroStr = wrkErroEx.ToString();
                if (wrkErroStr != null)
                {

                }

            }
        }
    }
}
