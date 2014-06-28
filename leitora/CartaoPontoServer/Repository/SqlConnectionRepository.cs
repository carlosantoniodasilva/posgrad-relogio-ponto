using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace CartaoPontoServer.Repository
{
    public static class SqlConnectionRepository
    {

        public const string ConnectionString = "Data Source=hxucb0bvlk.database.windows.net;Integrated Security=False;Initial Catalog=CartaoPontoServer_db; User ID=cartaoponto;Password=PwdPointCard2014;Connect Timeout=15;Encrypt=False;TrustServerCertificate=False";


        public static SqlConnection GetConnection()
        {
            SqlConnection wrkConn = new SqlConnection(ConnectionString);
            

            return null;
        }

    }
}