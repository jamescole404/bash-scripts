import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class ConnectMSSQLServer
{
   public void dbConnect(String db_connect_string,
            String db_userid,
            String db_password)
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(db_connect_string,
                  db_userid, db_password);
         System.out.println("connected");
         Statement statement = conn.createStatement();
         String queryString = "select * from sysobjects where type='u'";
         ResultSet rs = statement.executeQuery(queryString);
         while (rs.next()) {
            System.out.println(rs.getString(1));
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      ConnectMSSQLServer connServer = new ConnectMSSQLServer();
      connServer.dbConnect("jdbc:sqlserver://<hostname>", "<user>",
               "<password>");
   }
}



//Simple Java Program which connects to the SQL Server.

//NOTE: You need to add sqljdbc.jar into the build path

// localhost : local computer acts as a server

// 1433 : SQL default port number

// username : sa

// password: use password, which is used at the time of installing SQL server management studio, In my case, it is 'root'

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

    public class Conn {
        public static void main(String[] args) throws InstantiationException, IllegalAccessException, ClassNotFoundException {

            Connection conn=null;
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
                conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=company", "sa", "root");

                if(conn!=null)
                    System.out.println("Database Successfully connected");

            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    }
	


//    Try this.

    import java.sql.Connection;

    import java.sql.DriverManager;

    import java.sql.ResultSet;

    import java.sql.Statement;

    public class SQLUtil {

    public void dbConnect(String db_connect_string,String db_userid, String db_password) {

    try {

         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(db_connect_string,
                  db_userid, db_password);
         System.out.println("connected");
         Statement statement = conn.createStatement();
         String queryString = "select * from cpl";
         ResultSet rs = statement.executeQuery(queryString);
         while (rs.next()) {
            System.out.println(rs.getString(1));
         }
      } catch (Exception e) {
         e.printStackTrace();
      }    }

    public static void main(String[] args) {

    SQLUtil connServer = new SQLUtil();

    connServer.dbConnect("jdbc:sqlserver://192.168.10.97:1433;databaseName=myDB", "sa", "0123");

    }

    }



