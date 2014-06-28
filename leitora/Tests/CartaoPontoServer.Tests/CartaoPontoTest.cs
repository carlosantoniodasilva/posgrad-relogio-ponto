using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using CartaoPontoServer.Helpers;
using System.Collections.Generic;
using CartaoPontoServer.Models;

namespace CartaoPontoServer.Tests
{
    [TestClass]
    public class CartaoPontoTest
    {
        [TestMethod]
        public void CartaoPontoHelper_Test()
        {

            try
            {
                List<RegistroHora> wrkListaPonto = RegistroHoraHelper.GerarCartaoPonto(new DateTime(2014, 3, 1), null);
                if (wrkListaPonto != null && wrkListaPonto.Count > 0)
                {

                }

            }
            catch (Exception wrkEx)
            {
                string wrkErro = wrkEx.ToString();

                throw;
            }

        }
    }
}
