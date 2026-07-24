package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    private static final String URL = "jdbc:mysql://localhost:3306/VITALEM?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

   
    public static Connection conectar() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("Error Driver MySQL: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error Conexión SQL: " + e.getMessage());
        }
        return con;
    }

    /**
     * Método de instancia alternativo (mantiene compatibilidad con código anterior)
     */
    public Connection getConn() {
        return conectar();
    }
}