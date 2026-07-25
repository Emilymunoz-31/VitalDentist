package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private Connection conn;
    private String driver = "com.mysql.cj.jdbc.Driver";
    
    // Leemos las variables de entorno de Railway, con respaldos locales seguros
    private String host = System.getenv("MYSQLHOST") != null ? System.getenv("MYSQLHOST") : (System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost");
    private String port = System.getenv("MYSQLPORT") != null ? System.getenv("MYSQLPORT") : (System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306");
    private String baseDatos = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : (System.getenv("DB_DATABASE") != null ? System.getenv("DB_DATABASE") : "railway");
    private String user = System.getenv("MYSQLUSER") != null ? System.getenv("MYSQLUSER") : (System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root");
    private String password = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : (System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "");

    private String url = "jdbc:mysql://" + host + ":" + port + "/" + baseDatos + "?useTimezone=true&serverTimezone=America/Bogota&useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8";

    public Conexion() {
        conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, password);
            if (conn == null) {
                System.out.println("No se estableció la conexion \n" + url);
            } else {
                System.out.println("Conexión Establecida exitosamente con: " + host);
            }
        } catch (Exception ex) {
            System.err.println("Error de conexión SQL: " + ex.getMessage());
        }
    }

    public Connection getConn() {
        return conn;
    }
}
