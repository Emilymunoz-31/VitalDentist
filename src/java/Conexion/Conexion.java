package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // El driver se mantiene igual
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Credenciales de Railway
    private static final String USER = "root";
    private static final String PASSWORD = "LnYzjpZWAXzcRGksIVltbascMlAcSNog";
    
    // URL adaptada a JDBC con el host, puerto y base de datos de Railway
    private static final String URL = "jdbc:mysql://acela.proxy.rlwy.net:25413/railway?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    public static Connection conectar() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("¡Conexión exitosa a la BD en Railway!"); // Mensaje opcional para la consola
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
