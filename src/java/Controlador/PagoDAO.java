/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;


import Conexion.Conexion;
import Modelo.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Aprendiz
 */
public class PagoDAO {
       Conexion conexion = new Conexion();

   public boolean insertarPago(Pago pago) throws SQLException {
    boolean insertado = false;
    String sql = "INSERT INTO pago (` monto`, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita) VALUES (?, ?, ?, ?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setDouble(1, pago.getmonto());
        ps.setInt(2, pago.getMedio_pago_id_Mediopago());
        ps.setInt(3, pago.getEstado_pago_id_Estadopago());
        ps.setInt(4, pago.getCita_id_Cita());

        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Pago insertado con exito.");
        }
        
    } catch (SQLException e) {
        System.err.println("Error al insertar pago: " + e.getMessage());
        throw e;
    }
    return insertado;
}

    public java.util.List<Pago> listarPagos() {
        java.util.List<Pago> pagos = new java.util.ArrayList<>();
        
        // 💡 MAGIA SQL: Sumamos los abonos usando un IFNULL por si el paciente aún no ha pagado nada
        String sql = "SELECT p.id_Pago, p.` monto` AS monto_total, p.Medio_pago_idMedio_pago, "
                   + "p.Estado_pago_idEstado_pago, p.Cita_id_Cita, "
                   + "mp.descripcion_mediopa, ep.descripcion_estadop, "
                   + "IFNULL((SELECT SUM(a.monto_abono) FROM abono a WHERE a.Pago_id_Pago = p.id_Pago), 0.0) AS suma_abonos "
                   + "FROM pago p "
                   + "LEFT JOIN medio_pago mp ON p.Medio_pago_idMedio_pago = mp.id_Mediopago "
                   + "LEFT JOIN estado_pago ep ON p.Estado_pago_idEstado_pago = ep.id_Estadopago "
                   + "ORDER BY p.id_Pago DESC";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Pago pago = new Pago();
                pago.setid_Pago(rs.getInt("id_Pago"));
                
                // Ojo aquí: capturamos el total del contrato
                Double montoTotal = rs.getDouble("monto_total");
                pago.setmonto(montoTotal);
                
                pago.setMedio_pago_id_Mediopago(rs.getInt("Medio_pago_idMedio_pago"));
                pago.setEstado_pago_id_Estadopago(rs.getInt("Estado_pago_idEstado_pago"));
                pago.setCita_id_Cita(rs.getInt("Cita_id_Cita"));
                pago.setDescripcionMedioPago(rs.getString("descripcion_mediopa"));
                pago.setDescripcionEstadoPago(rs.getString("descripcion_estadop"));
                
                // 💡 CALCULAMOS EL SALDO PENDIENTE
                Double abonado = rs.getDouble("suma_abonos");
                pago.setTotalAbonado(abonado);
                
                Double pendiente = montoTotal - abonado;
                pago.setSaldoPendiente(pendiente < 0 ? 0.0 : pendiente);
                
                pagos.add(pago);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar pagos: " + e.getMessage());
        }
        return pagos;
    }
    
    
    
    public Pago consultaPago(int id_Pago) {

        Pago pago = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {

            String querySQL = "SELECT id_Pago, ` monto`, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita FROM Pago WHERE id_Pago = ?";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, id_Pago);
           
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                pago = new Pago();
                pago.setid_Pago(rs.getInt(1));
                pago.setmonto(rs.getDouble(2));
                pago.setMedio_pago_id_Mediopago(rs.getInt(3));
                pago.setEstado_pago_id_Estadopago(rs.getInt(4));
                pago.setCita_id_Cita(rs.getInt(5));
            }

            return pago;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return pago;

        }
    }
    
  public boolean actualizarPago(Pago pago) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE Pago SET ` monto`=?, Medio_pago_idMedio_pago=?, Estado_pago_idEstado_pago=?, Cita_id_Cita=? WHERE id_Pago=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, pago.getmonto());
            ps.setInt(2, pago.getMedio_pago_id_Mediopago());
            ps.setInt(3, pago.getEstado_pago_id_Estadopago());
            ps.setInt(4, pago.getCita_id_Cita());
            ps.setInt(5, pago.getid_Pago());
            
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Pago: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarPago(int id) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM pago WHERE id_Pago = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el pago  " + e.getMessage());
        }
        return eliminado;
    }
    public Integer obtenerIdEstadoPorDescripcion(String descripcion) {
        String sql = "SELECT id_Estadopago FROM Estado_pago "
                + "WHERE LOWER(TRIM(REPLACE(descripcion_estadop, '.', ''))) = LOWER(TRIM(REPLACE(?, '.', ''))) "
                + "OR LOWER(TRIM(descripcion_estadop)) LIKE LOWER(?) "
                + "ORDER BY id_Estadopago LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String valor = descripcion == null ? "" : descripcion.trim();
            ps.setString(1, valor);
            ps.setString(2, valor + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_Estadopago");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estado de pago: " + e.getMessage());
        }
        return null;
    }

    public Integer obtenerPrimerMedioPagoDisponible() {
        String sql = "SELECT id_Mediopago FROM Medio_pago ORDER BY id_Mediopago LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_Mediopago");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener medio de pago: " + e.getMessage());
        }
        return null;
    }

    public Pago obtenerPagoPorCita(int idCita) {
        Pago pago = null;
        String sql = "SELECT id_Pago, ` monto`, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita "
                + "FROM pago WHERE Cita_id_Cita = ? ORDER BY id_Pago DESC LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pago = new Pago();
                    pago.setid_Pago(rs.getInt("id_Pago"));
                    pago.setmonto(rs.getDouble(" monto"));
                    pago.setMedio_pago_id_Mediopago(rs.getInt("Medio_pago_idMedio_pago"));
                    pago.setEstado_pago_id_Estadopago(rs.getInt("Estado_pago_idEstado_pago"));
                    pago.setCita_id_Cita(rs.getInt("Cita_id_Cita"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener pago por cita: " + e.getMessage());
        }
        return pago;
    }

    public double calcularSaldoPendiente(int idCita) {
        String sql = "SELECT COALESCE(tt.costo, 0) - COALESCE(SUM(a.monto_abono), 0) AS saldo "
                + "FROM cita c "
                + "LEFT JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
                + "LEFT JOIN pago p ON p.Cita_id_Cita = c.id_Cita "
                + "LEFT JOIN abono a ON a.Pago_id_Pago = p.id_Pago "
                + "WHERE c.id_Cita = ? "
                + "GROUP BY c.id_Cita, tt.costo";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.max(0, rs.getDouble("saldo"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al calcular saldo pendiente: " + e.getMessage());
        }
        return 0;
    }
}  

