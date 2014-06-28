using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using CartaoPontoServer.Models;

namespace CartaoPontoServer.Helpers
{
    public static class RegistroHoraHelper
    {
        /// <summary>
        /// Gerar Cartao Ponto simulando registros de horas
        /// </summary>
        /// <param name="pDataInicial"></param>
        /// <param name="pDataFinal"></param>
        /// <remarks></remarks>
        /// <returns></returns>
        public static List<RegistroHora> GerarCartaoPonto(DateTime pDataInicial, Nullable<DateTime> pDataFinal)
        {
            if (pDataFinal == null)
                pDataFinal = DateTime.Now;

            List<RegistroHora> wrkListaPonto = new List<RegistroHora>();

            DateTime wrkDataAtual;

            Random wrkRandom = new Random();

            //random para numero de registros no dia
            while (pDataInicial < pDataFinal)
            {
                wrkDataAtual = pDataInicial;

                //Ignorar Sabado e Domingo
                if (wrkDataAtual.DayOfWeek != DayOfWeek.Saturday && wrkDataAtual.DayOfWeek != DayOfWeek.Sunday)
                {
                    
                    int wrkNrRegistroDia = wrkRandom.Next(0, 4);
                    if (wrkNrRegistroDia == 1)
                        wrkNrRegistroDia = 2;
                    else if (wrkNrRegistroDia == 3)
                        wrkNrRegistroDia = 4;

                    string wrkHoraPonto = null;
                    int wrkAux = 0;

                    for (int wrkHoraDia = 0; wrkHoraDia < wrkNrRegistroDia; wrkHoraDia++)
                    {
                        RegistroHora wrkNewPonto = new RegistroHora();
                        wrkNewPonto.DataRegistro = wrkDataAtual.ToShortDateString();
                        wrkAux = 0;
                        

                        switch (wrkHoraDia + 1)
                        {   
                            case 1:
                                wrkHoraPonto = wrkRandom.Next(74359, 83159).ToString(); //07:43:59 - 08:31:59

                                //Ajusta as horas se necessario
                                wrkAux = Convert.ToInt32(wrkHoraPonto.Substring(1, 1));
                                if (wrkAux > 5)
                                    wrkHoraPonto = string.Concat(wrkHoraPonto.Substring(0, 1), "5", wrkHoraPonto.Substring(2, 3));

                                wrkAux = Convert.ToInt32(wrkHoraPonto.Substring(3, 1));
                                if (wrkAux > 5)
                                    wrkHoraPonto = string.Concat(wrkHoraPonto.Substring(0, 3), "5", wrkHoraPonto.Substring(4, 1));

                                break;
                            case 2:
                                wrkHoraPonto = wrkRandom.Next(114759, 123259).ToString(); //11:47:59 - 12:32:59
                                break;
                            case 3:
                                wrkHoraPonto = wrkRandom.Next(130559, 134759).ToString(); //13:05:59 - 13:47:59
                                break;
                            case 4:
                                wrkHoraPonto = wrkRandom.Next(174359, 181759).ToString(); //17:43:59 - 18:17:59
                                break;

                            default:
                                break;
                        }

                        if (wrkHoraDia > 0)
                        {
                            //Ajusta as horas se necessario
                            wrkAux = Convert.ToInt32(wrkHoraPonto.Substring(2, 1));
                            if (wrkAux > 5)
                                wrkHoraPonto = string.Concat(wrkHoraPonto.Substring(0, 2), "5", wrkHoraPonto.Substring(3, 3));

                            wrkAux = Convert.ToInt32(wrkHoraPonto.Substring(4, 1));
                            if (wrkAux > 5)
                                wrkHoraPonto = string.Concat(wrkHoraPonto.Substring(0, 4), "5", wrkHoraPonto.Substring(5, 1));
                        }

                        wrkHoraPonto = wrkHoraPonto.PadLeft(6, Convert.ToChar("0"));
                        wrkHoraPonto = string.Format("{0}:{1}:{2}", wrkHoraPonto.Substring(0, 2), wrkHoraPonto.Substring(2, 2), 
                                                                    wrkHoraPonto.Substring(4, 2));

                        wrkNewPonto.HoraRegistro = wrkHoraPonto;

                        wrkNewPonto.AddDtRegistro();

                        wrkListaPonto.Add(wrkNewPonto);
                    }
                }

                pDataInicial = pDataInicial.AddDays(1);
            }

            return wrkListaPonto;
        }

    }
}