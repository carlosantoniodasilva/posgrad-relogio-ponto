using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Text;

using CartaoPontoServer.Models;

namespace CartaoPontoServer.Repository
{
    public class RegistroHoraRepository
    {
        private List<RegistroHora> registros = new List<RegistroHora>();

        public RegistroHoraRepository()
        {
            //this.GerarRegistroPontoTeste(null);
        }

        public RegistroHoraRepository(Funcionario pFuncionario)
        {
            //this.GerarRegistroPontoTeste(pFuncionario);
        }

        public IEnumerable<RegistroHora> GetAll()
        {
            List<RegistroHora> wrkRegistros = null;

            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;

            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("SELECT * ");
                wrkSQL.Append("FROM RegistroHora ");
                wrkSQL.Append("WHERE FgLido = @FgLido ");
                wrkSQL.Append("and DtRegistro <= @DtRegistro ");
                wrkCmd.Parameters.Add(new SqlParameter("@FgLido", false));
                wrkCmd.Parameters.Add(new SqlParameter("@DtRegistro", Convert.ToDateTime(DateTime.Now.AddDays(-1).ToShortDateString() + " 23:59:59")));

                wrkCmd.CommandText = wrkSQL.ToString();

                wrkConn.Open();
                SqlDataReader wrkReader = wrkCmd.ExecuteReader();
                if (wrkReader != null)
                {
                    wrkRegistros = new List<RegistroHora>();

                    while (wrkReader.Read())
                    {
                        RegistroHora wrkRegistro = new RegistroHora();
                        wrkRegistro.Id = wrkReader.GetInt32(0);
                        wrkRegistro.Funcionario = new Funcionario();
                        wrkRegistro.Funcionario.Id = wrkReader.GetInt32(1);
                        wrkRegistro.Funcionario.Nome = wrkReader.GetString(2);
                        wrkRegistro.DataRegistro = wrkReader.GetString(3);
                        wrkRegistro.HoraRegistro = wrkReader.GetString(4);
                        wrkRegistros.Add(wrkRegistro);
                    }
                }
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();

                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();

                    wrkConn.Dispose();
                }

            }

            return wrkRegistros;
        }

        public IEnumerable<RegistroHora> GetAllByFuncionario(int pIdFuncionario)
        {
            List<RegistroHora> wrkRegistros = new List<RegistroHora>();

            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;

            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("SELECT * ");
                wrkSQL.Append("FROM RegistroHora ");
                wrkSQL.Append("WHERE IdFuncionario = @IdFuncionario AND FgLido = @FgLido ");
                wrkSQL.Append("and DtRegistro <= @DtRegistro ");
                wrkCmd.Parameters.Add(new SqlParameter("@IdFuncionario", pIdFuncionario));
                wrkCmd.Parameters.Add(new SqlParameter("@FgLido", false));
                wrkCmd.Parameters.Add(new SqlParameter("@DtRegistro", Convert.ToDateTime(DateTime.Now.AddDays(-1).ToShortDateString() + " 23:59:59")));

                wrkCmd.CommandText = wrkSQL.ToString();

                wrkConn.Open();
                SqlDataReader wrkReader = wrkCmd.ExecuteReader();
                if (wrkReader != null)
                {
                    while (wrkReader.Read())
                    {
                        RegistroHora wrkRegistro = new RegistroHora();
                        wrkRegistro.Id = wrkReader.GetInt32(0);
                        wrkRegistro.Funcionario = new Funcionario();
                        wrkRegistro.Funcionario.Id = wrkReader.GetInt32(1);
                        wrkRegistro.Funcionario.Nome = wrkReader.GetString(2);
                        wrkRegistro.DataRegistro = wrkReader.GetString(3);
                        wrkRegistro.HoraRegistro = wrkReader.GetString(4);
                        wrkRegistros.Add(wrkRegistro);
                    }
                }
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();

                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();

                    wrkConn.Dispose();
                }
            }

            return wrkRegistros;
        }

        public RegistroHora Get(int id)
        {
            return registros.Find(p => p.Id == id);
        }




        public void Add(List<RegistroHora> pRegistros)
        {
            //bool wrkErro = true;
            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;
            //SqlTransaction wrkTrans = null;

            try
            {
                //Inicializa transacao
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;
                wrkCmd.Connection.Open();
                //wrkTrans = wrkConn.BeginTransaction();
                //wrkCmd.Transaction = wrkTrans;
                //====================
                foreach (RegistroHora wrkRegistro in pRegistros)
                {
                    this.Add(wrkCmd, wrkRegistro);
                }
                //wrkTrans.Commit();
                //Indica que nao houve erro na atualizacao
                //wrkErro = false;
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                    {
                        //if (wrkErro)
                        //{
                        //    try
                        //    {
                        //        if (wrkTrans != null)
                        //            wrkTrans.Rollback();
                        //    }
                        //    catch (Exception)
                        //    { }
                        //}
                        wrkCmd.Connection.Close();
                        wrkCmd.Connection.Dispose();
                    }
                    //if (wrkTrans != null)
                    //    wrkTrans = null;
                    wrkCmd.Dispose();
                }
            }
        }

        public void Add(RegistroHora item)
        {
            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;

            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("INSERT INTO RegistroHora (");
                wrkSQL.Append("IdFuncionario, NomeFuncionario, DataRegistro, HoraRegistro, FgLido)");
                wrkSQL.Append("VALUES ( ");
                wrkSQL.Append("@IdFuncionario, @NomeFuncionario, @DataRegistro, @HoraRegistro, @FgLido)");
                wrkCmd.Parameters.Add(new SqlParameter("@IdFuncionario", item.Funcionario.Id));
                wrkCmd.Parameters.Add(new SqlParameter("@NomeFuncionario", item.Funcionario.Nome));
                wrkCmd.Parameters.Add(new SqlParameter("@DataRegistro", item.DataRegistro));
                wrkCmd.Parameters.Add(new SqlParameter("@HoraRegistro", item.HoraRegistro));
                wrkCmd.Parameters.Add(new SqlParameter("@FgLido", false));

                wrkCmd.CommandText = wrkSQL.ToString();
                wrkConn.Open();
                wrkCmd.ExecuteNonQuery();
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();

                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();

                    wrkConn.Dispose();
                }
            }
        }

        public void Add(SqlCommand pCmd, RegistroHora item)
        {
            StringBuilder wrkSQL = new StringBuilder();
            wrkSQL.Append("INSERT INTO RegistroHora (");
            wrkSQL.Append("IdFuncionario, NomeFuncionario, DataRegistro, HoraRegistro, FgLido, DtRegistro)");
            wrkSQL.Append("VALUES ( ");
            wrkSQL.Append("@IdFuncionario, @NomeFuncionario, @DataRegistro, @HoraRegistro, @FgLido, @DtRegistro)");
            pCmd.Parameters.Clear();
            pCmd.Parameters.Add(new SqlParameter("@IdFuncionario", item.Funcionario.Id));
            pCmd.Parameters.Add(new SqlParameter("@NomeFuncionario", item.Funcionario.Nome));
            pCmd.Parameters.Add(new SqlParameter("@DataRegistro", item.DataRegistro));
            pCmd.Parameters.Add(new SqlParameter("@HoraRegistro", item.HoraRegistro));
            pCmd.Parameters.Add(new SqlParameter("@FgLido", false));
            pCmd.Parameters.Add(new SqlParameter("@DtRegistro", item.GetDtRegistro()));

            pCmd.CommandText = wrkSQL.ToString();
            pCmd.ExecuteNonQuery();
        }

        public void GerarCartaoPontoFuncionario(int pIdfuncioario, string pNomeFuncionario, DateTime pDataInicial,
                                                 DateTime pDataFinal)
        {
            this.GerarRegistroPontoTeste(new Funcionario() { Id = pIdfuncioario, Nome = pNomeFuncionario }, pDataInicial, pDataFinal);

            this.RemoveByFuncionario(pIdfuncioario);

            this.Add(this.registros);
        }

        public void Remove(int id)
        {
            registros.RemoveAll(p => p.Id == id);
        }

        public void RemoveByFuncionario(int pIdFuncionario)
        {
            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;
            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("DELETE FROM RegistroHora ");
                wrkSQL.Append("WHERE IdFuncionario = @IdFuncionario");
                wrkCmd.Parameters.Add(new SqlParameter("@IdFuncionario", pIdFuncionario));

                wrkCmd.CommandText = wrkSQL.ToString();
                wrkConn.Open();
                wrkCmd.ExecuteNonQuery();
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();
                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();
                    wrkConn.Dispose();
                }
            }
        }

        public bool Update(RegistroHora item)
        {
            if (item == null)
            {
                throw new ArgumentNullException("item");
            }
            int index = registros.FindIndex(p => p.Id == item.Id);
            if (index == -1)
            {
                return false;
            }
            registros.RemoveAt(index);
            registros.Add(item);
            return true;
        }

        //1 Ademar
        //2 Carlos
        //3 Fabricio
        //4 Nilson

        private void GerarRegistroPontoTeste(Funcionario pFuncionario, DateTime pDataInicial, DateTime pDataFinal)
        {
            if (pDataFinal == null)
            {
                pDataFinal = DateTime.Now;
            }

            this.registros = CartaoPontoServer.Helpers.RegistroHoraHelper.GerarCartaoPonto(pDataInicial, pDataFinal);
            if (this.registros != null && this.registros.Count > 0)
            {
                foreach (RegistroHora wrkRegistro in registros)
                {
                    wrkRegistro.Funcionario = pFuncionario;
                }
            }


        }




        public void MarcarComoLidoRegistroFuncionario(int pIdFuncionario)
        {
            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;
            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("UPDATE RegistroHora ");
                wrkSQL.Append("SET FgLido = @FgLido ");
                wrkSQL.Append("WHERE IdFuncionario = @IdFuncionario ");
                wrkSQL.Append("and DtRegistro <= @DtRegistro ");

                wrkCmd.Parameters.Add(new SqlParameter("@FgLido", true));
                wrkCmd.Parameters.Add(new SqlParameter("@IdFuncionario", pIdFuncionario));
                wrkCmd.Parameters.Add(new SqlParameter("@DtRegistro", Convert.ToDateTime(DateTime.Now.AddDays(-1).ToShortDateString() + " 23:59:59")));

                wrkCmd.CommandText = wrkSQL.ToString();
                wrkConn.Open();
                wrkCmd.ExecuteNonQuery();
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();
                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();
                    wrkConn.Dispose();
                }
            }
        }

        public void MarcarComoLidoTodosRegistros()
        {
            SqlConnection wrkConn = null;
            SqlCommand wrkCmd = null;
            try
            {
                wrkConn = new SqlConnection(SqlConnectionRepository.ConnectionString);
                wrkCmd = new SqlCommand();
                wrkCmd.CommandType = System.Data.CommandType.Text;
                wrkCmd.Connection = wrkConn;

                StringBuilder wrkSQL = new StringBuilder();
                wrkSQL.Append("UPDATE RegistroHora ");
                wrkSQL.Append("SET FgLido = @FgLido ");
                wrkSQL.Append("WHERE DtRegistro <= @DtRegistro ");

                wrkCmd.Parameters.Add(new SqlParameter("@FgLido", true));
                wrkCmd.Parameters.Add(new SqlParameter("@DtRegistro", Convert.ToDateTime(DateTime.Now.AddDays(-1).ToShortDateString() + " 23:59:59")));

                wrkCmd.CommandText = wrkSQL.ToString();
                wrkConn.Open();
                wrkCmd.ExecuteNonQuery();
            }
            finally
            {
                if (wrkCmd != null)
                {
                    if (wrkCmd.Connection != null)
                        wrkCmd.Connection.Close();
                    wrkCmd.Dispose();
                }
                if (wrkConn != null)
                {
                    if (wrkConn.State != System.Data.ConnectionState.Closed)
                        wrkConn.Close();
                    wrkConn.Dispose();
                }
            }
        }

    }
}