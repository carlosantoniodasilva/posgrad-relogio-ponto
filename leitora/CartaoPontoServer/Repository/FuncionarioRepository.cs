using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CartaoPontoServer.Models;

namespace CartaoPontoServer.Repository
{
    public class FuncionarioRepository
    {

        private List<Funcionario> funcionarios = new List<Funcionario>();
        private int _nextId = 1;

        public FuncionarioRepository()
        {
            Add(new Funcionario { Id = 1, Nome = "Ademar" });
            Add(new Funcionario { Id = 2, Nome = "Carlos" });
            Add(new Funcionario { Id = 3, Nome = "Fabricio" });
            Add(new Funcionario { Id = 4, Nome = "Nilson" });
        }

        public IEnumerable<Funcionario> GetAll()
        {
            return funcionarios;
        }

        public Funcionario Get(int id)
        {
            return funcionarios.Find(p => p.Id == id);
        }

        public Funcionario Add(Funcionario item)
        {
            if (item == null)
            {
                throw new ArgumentNullException("item");
            }
            item.Id = _nextId++;
            funcionarios.Add(item);
            return item;
        }

        public void Remove(int id)
        {
            funcionarios.RemoveAll(p => p.Id == id);
        }

        public bool Update(Funcionario item)
        {
            if (item == null)
            {
                throw new ArgumentNullException("item");
            }
            int index = funcionarios.FindIndex(p => p.Id == item.Id);
            if (index == -1)
            {
                return false;
            }
            funcionarios.RemoveAt(index);
            funcionarios.Add(item);
            return true;
        }
    
    }
}