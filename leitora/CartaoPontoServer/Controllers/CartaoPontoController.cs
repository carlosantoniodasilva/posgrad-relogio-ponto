using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CartaoPontoServer.Repository;
using CartaoPontoServer.ViewsModel;

namespace CartaoPontoServer.Controllers
{
    public class CartaoPontoController : Controller
    {
        // GET: CartaoPonto
        public ActionResult Index()
        {
            return View();
        }

        // GET: CartaoPonto/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: CartaoPonto/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CartaoPonto/Create
        [HttpPost]
        public ActionResult Create(CartaoPontoViewModel cartaoPontoViewModel)
        {
            try
            {
                RegistroHoraRepository repository = new RegistroHoraRepository();
                repository.GerarCartaoPontoFuncionario(cartaoPontoViewModel.IdFuncionario, cartaoPontoViewModel.NomeFuncionario,
                                                        cartaoPontoViewModel.DtInicio, cartaoPontoViewModel.DtFim);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: CartaoPonto/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        
        public ActionResult LiberarPonto(FormCollection collection)
        {
            return View();
        }



        // POST: CartaoPonto/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: CartaoPonto/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: CartaoPonto/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

    }
}
