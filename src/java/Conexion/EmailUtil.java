package Conexion; // o util / Controlador según tu paquete

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    private static final String REMITENTE = "vitaldentistnotificaciones@gmail.com";
    private static final String CLAVE_APLICACION = "wqmbkielrnhgegdf";

    private static Session obtenerSesion() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        // Desactiva la verificación estricta del certificado SSL local
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.checkserveridentity", "false");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMITENTE, CLAVE_APLICACION);
            }
        });
    }

    public static boolean enviarCodigoRecuperacion(String correoDestino, String codigo) {
        try {
            Session session = obtenerSesion();
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(REMITENTE, "VitalDentist Notificaciones"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correoDestino));
            message.setSubject("Recuperación de Contraseña - VitalDentist");

            String cuerpoHTML = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                    + "<h2 style='color: #0d6efd;'>VitalDentist</h2>"
                    + "<p>Hemos recibido una solicitud para restablecer tu contraseña.</p>"
                    + "<p>Tu código de seguridad temporal es:</p>"
                    + "<h1 style='background-color: #f8f9fa; display: inline-block; padding: 10px 20px; color: #0d6efd; border-radius: 5px;'>" + codigo + "</h1>"
                    + "<p>Ingresa este código para acceder y actualizar tu clave.</p>"
                    + "</div>";

            message.setContent(cuerpoHTML, "text/html; charset=utf-8");
            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Envía la notificación y orden de la cita agendada al correo del paciente
     */
    public static boolean enviarConfirmacionCita(String correo, String nombrePaciente, String fecha_hora, String Tipo_Tratamiento, String descripcion_cita) {
        try {
            Session session = obtenerSesion();
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(REMITENTE, "VitalDentist Notificaciones"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correo));
            message.setSubject("Confirmación de Cita Odontológica - VitalDentist");

            String cuerpoHTML = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #e0e0e0; border-radius: 12px; max-width: 600px; margin: auto; background-color: #fdfdfd;'>"
                    + "<div style='text-align: center; border-bottom: 2px solid #274c77; padding-bottom: 15px; margin-bottom: 20px;'>"
                    + "  <h2 style='color: #274c77; margin: 0;'>VitalDentist</h2>"
                    + "  <p style='color: #6096ba; font-size: 14px; margin: 5px 0 0;'>Orden y Confirmación de Cita Médica</p>"
                    + "</div>"
                    + "<p>Hola <strong>" + nombrePaciente + "</strong>,</p>"
                    + "<p>Tu cita odontológica ha sido agendada con éxito en nuestro sistema. A continuación, te compartimos los detalles importantes:</p>"
                    + "<table style='width: 100%; border-collapse: collapse; margin-top: 15px; background-color: #f8fafc; border-radius: 8px; overflow: hidden;'>"
                    + "  <tr><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #475569;'><strong>Tratamiento:</strong></td><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #1e293b;'>" + Tipo_Tratamiento + "</td></tr>"
                    + "  <tr><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #475569;'><strong>Fecha y Hora:</strong></td><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #1e293b;'>" + fecha_hora + "</td></tr>"
                    + "  <tr><td style='padding: 12px; color: #475569;'><strong>Observaciones:</strong></td><td style='padding: 12px; color: #1e293b;'>" + (descripcion_cita != null ? descripcion_cita : "Ninguna") + "</td></tr>"
                    + "</table>"
                    + "<br><div style='background-color: #edf5f8; padding: 12px; border-radius: 6px; font-size: 13px; color: #274c77;'>"
                    + "  <strong>Recomendaciones:</strong> Por favor preséntate en nuestra clínica 10 minutos antes de la hora programada. Si necesitas cancelar o reprogramar, comunícate con anticipación."
                    + "</div>"
                    + "<p style='margin-top: 25px; font-size: 13px; color: #94a3b8; text-align: center;'>Atentamente,<br><strong>Equipo Clínica Odontológica VitalDentist</strong></p>"
                    + "</div>";

            message.setContent(cuerpoHTML, "text/html; charset=utf-8");
            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}