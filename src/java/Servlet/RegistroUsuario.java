package Servlet;

import Controlador.RolDAO;
import Controlador.Tipo_documentoDAO;
import Controlador.UsuarioDAO;
import Modelo.Rol;
import Modelo.Usuario;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RegistroUsuario", urlPatterns = {"/RegistroUsuarioServlet", "/Registro_Usuario"})
public class RegistroUsuario extends HttpServlet {

    private static final String VISTA_REGISTRO = "/Vista/Registro_Usuario.jsp";
    private static final Pattern SOLO_LETRAS = Pattern.compile("^[\\p{L} .'-]{2,60}$");
    private static final Pattern SOLO_NUMEROS = Pattern.compile("^[0-9]{5,15}$");
    private static final Pattern TELEFONO = Pattern.compile("^[0-9]{7,15}$");
    private static final Pattern CORREO = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!esAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/Vista/odontologo_inicio.jsp");
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarUsuario(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroUsuarioServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }

        cargarSelectores(request);
        if ("editar".equals(accion)) {
            try {
                Usuario usuarioEditar = dao.consultaUsuario(Integer.parseInt(limpiar(request.getParameter("id"))));
                request.setAttribute("usuarioEditar", usuarioEditar);
                request.setAttribute("valores", valoresDesdeUsuario(usuarioEditar));
            } catch (Exception e) {
                request.setAttribute("usuarioEditar", null);
            }
        }

        if ("exitoso".equals(request.getParameter("registro"))) {
            request.setAttribute("mensajeExito", "Usuario registrado exitosamente.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(VISTA_REGISTRO);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Map<String, String> errores = new LinkedHashMap<>();
        Map<String, String> valores = obtenerValoresFormulario(request);
        String accion = limpiar(request.getParameter("accion"));
        int idUsuarioActualizar = 0;
        if ("actualizar".equals(accion)) {
            try {
                idUsuarioActualizar = Integer.parseInt(limpiar(request.getParameter("id")));
            } catch (NumberFormatException e) {
                errores.put("general", "No fue posible identificar el usuario a actualizar.");
            }
        }

        String nombres = valores.get("txtNombres");
        String apellidos = valores.get("txtApellidos");
        String tipoDocumento = valores.get("txtTipoDoc");
        String documento = valores.get("txtDocumento");
        String fechaNacimiento = valores.get("txtFechaNac");
        String rol = valores.get("txtRol");
        String correo = valores.get("txtCorreo");
        String telefono = valores.get("txtTelefono");
        String contrasena = valores.get("txtPassword");
        boolean tratamientoDatos = "on".equalsIgnoreCase(limpiar(request.getParameter("tratamientoDatos")));
        boolean registroPaciente = "true".equalsIgnoreCase(limpiar(request.getParameter("registroPaciente")));
        String redireccion = limpiar(request.getParameter("redireccion"));

        if (registroPaciente) {
            rol = "Paciente";
            contrasena = "PACIENTE_SIN_ACCESO_" + documento;
            valores.put("txtRol", rol);
            valores.put("txtPassword", contrasena);
        }

        validarTextoObligatorio(errores, "txtNombres", nombres, "Los nombres son obligatorios y solo deben contener letras.");
        validarTextoObligatorio(errores, "txtApellidos", apellidos, "Los apellidos son obligatorios y solo deben contener letras.");

        Integer idTipoDocumento = resolverTipoDocumento(tipoDocumento);
        if (idTipoDocumento == null) {
            errores.put("txtTipoDoc", "Seleccione un tipo de documento valido.");
        }

        if (documento.isEmpty()) {
            errores.put("txtDocumento", "El numero de documento es obligatorio.");
        } else if (!SOLO_NUMEROS.matcher(documento).matches()) {
            errores.put("txtDocumento", "El documento debe tener entre 5 y 15 digitos.");
        }

        Date fechaNacimientoSql = validarFechaNacimiento(errores, fechaNacimiento);

        Integer idRol = registroPaciente ? resolverRolPaciente() : resolverRol(rol);
        if (idRol == null) {
            errores.put("txtRol", "Seleccione un rol valido.");
        }

        if (!esAdministrador(request) && !registroPaciente && !esRolPaciente(idRol, rol)) {
            response.sendRedirect(request.getContextPath() + "/Vista/odontologo_inicio.jsp");
            return;
        }

        if (correo.isEmpty()) {
            errores.put("txtCorreo", "El correo electronico es obligatorio.");
        } else if (!CORREO.matcher(correo).matches()) {
            errores.put("txtCorreo", "Ingrese un correo electronico valido.");
        }

        if (telefono.isEmpty()) {
            errores.put("txtTelefono", "El telefono es obligatorio.");
        } else if (!TELEFONO.matcher(telefono).matches()) {
            errores.put("txtTelefono", "El telefono debe contener entre 7 y 15 digitos.");
        }

        if (!registroPaciente && contrasena.isEmpty()) {
            errores.put("txtPassword", "La contraseÃ±a temporal es obligatoria.");
        } else if (!registroPaciente && contrasena.length() < 6) {
            errores.put("txtPassword", "La contraseÃ±a debe tener minimo 6 caracteres.");
        }

        if (!tratamientoDatos) {
            errores.put("tratamientoDatos", "Debe aceptar el tratamiento de datos.");
        }

        Usuario usuarioActual = idUsuarioActualizar > 0 ? new UsuarioDAO().consultaUsuario(idUsuarioActualizar) : null;
        boolean documentoCambio = usuarioActual == null || !documento.equals(usuarioActual.getDocumento());
        boolean correoCambio = usuarioActual == null || !correo.equalsIgnoreCase(usuarioActual.getCorreo() == null ? "" : usuarioActual.getCorreo());

        if (!documento.isEmpty() && documentoCambio && !errores.containsKey("txtDocumento") && new UsuarioDAO().existeDocumento(documento)) {
            errores.put("txtDocumento", "Ya existe un usuario registrado con este documento.");
        }
        if (!correo.isEmpty() && correoCambio && !errores.containsKey("txtCorreo") && new UsuarioDAO().existeCorreo(correo)) {
            errores.put("txtCorreo", "Ya existe un usuario registrado con este correo.");
        }

        if (!errores.isEmpty()) {
            if (registroPaciente && !redireccion.isEmpty()) {
                response.sendRedirect(request.getContextPath() + redireccionConParametro(redireccion, "paciente_error", "datos_invalidos"));
                return;
            }
            responderConErrores(request, response, errores, valores);
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreus(nombres);
        nuevoUsuario.setApellido(apellidos);
        nuevoUsuario.setDocumento(documento);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setTelefono(telefono);
        nuevoUsuario.setContrasena(contrasena);
        nuevoUsuario.setfecha_nacimiento(fechaNacimientoSql);
        nuevoUsuario.settratamiento_datos(tratamientoDatos);
        nuevoUsuario.setRol_id_Rol(idRol);
        nuevoUsuario.setTipo_documento_id_Tipodocumento(idTipoDocumento);
        nuevoUsuario.setId_Usuario(idUsuarioActualizar);

        try {
            boolean ok = "actualizar".equals(accion)
                    ? new UsuarioDAO().actualizarUsuario(nuevoUsuario)
                    : new UsuarioDAO().insertarUsuario(nuevoUsuario);
            if (ok) {
                if (!redireccion.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redireccionConParametro(redireccion, "paciente_registrado", "1"));
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/RegistroUsuarioServlet?registro=exitoso");
                return;
            }
            errores.put("general", "No se pudo registrar el usuario. Verifique los datos e intentelo nuevamente.");
        } catch (SQLException e) {
            errores.put("general", "Ocurrio un error al guardar el usuario: " + e.getMessage());
        }

        if (registroPaciente && !redireccion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + redireccionConParametro(redireccion, "paciente_error", "registro"));
            return;
        }
        responderConErrores(request, response, errores, valores);
    }

    private void cargarSelectores(HttpServletRequest request) {
        request.setAttribute("roles", new RolDAO().listarRoles());
        request.setAttribute("tiposDocumento", new Tipo_documentoDAO().listarTiposDocumento());
        request.setAttribute("usuarios", new UsuarioDAO().listarUsuarios());
    }

    private Map<String, String> obtenerValoresFormulario(HttpServletRequest request) {
        Map<String, String> valores = new LinkedHashMap<>();
        valores.put("txtNombres", limpiar(request.getParameter("txtNombres")));
        valores.put("txtApellidos", limpiar(request.getParameter("txtApellidos")));
        valores.put("txtTipoDoc", limpiar(request.getParameter("txtTipoDoc")));
        valores.put("txtDocumento", limpiar(request.getParameter("txtDocumento")));
        valores.put("txtFechaNac", limpiar(request.getParameter("txtFechaNac")));
        valores.put("txtRol", limpiar(request.getParameter("txtRol")));
        valores.put("txtCorreo", limpiar(request.getParameter("txtCorreo")));
        valores.put("txtTelefono", limpiar(request.getParameter("txtTelefono")));
        valores.put("txtPassword", limpiar(request.getParameter("txtPassword")));
        return valores;
    }

    private Map<String, String> valoresDesdeUsuario(Usuario usuario) {
        Map<String, String> valores = new LinkedHashMap<>();
        if (usuario == null) {
            return valores;
        }
        valores.put("txtNombres", usuario.getNombreus());
        valores.put("txtApellidos", usuario.getApellido());
        valores.put("txtTipoDoc", String.valueOf(usuario.getTipo_documento_id_Tipodocumento()));
        valores.put("txtDocumento", usuario.getDocumento());
        valores.put("txtFechaNac", usuario.getfecha_nacimiento() == null ? "" : usuario.getfecha_nacimiento().toString());
        valores.put("txtRol", String.valueOf(usuario.getRol_id_Rol()));
        valores.put("txtCorreo", usuario.getCorreo());
        valores.put("txtTelefono", usuario.getTelefono());
        valores.put("txtPassword", usuario.getContrasena());
        return valores;
    }

    private void validarTextoObligatorio(Map<String, String> errores, String campo, String valor, String mensaje) {
        if (valor.isEmpty() || !SOLO_LETRAS.matcher(valor).matches()) {
            errores.put(campo, mensaje);
        }
    }

    private Date validarFechaNacimiento(Map<String, String> errores, String fechaNacimiento) {
        if (fechaNacimiento.isEmpty()) {
            errores.put("txtFechaNac", "La fecha de nacimiento es obligatoria.");
            return null;
        }

        try {
            LocalDate fecha = LocalDate.parse(fechaNacimiento);
            if (fecha.isAfter(LocalDate.now())) {
                errores.put("txtFechaNac", "La fecha de nacimiento no puede ser futura.");
                return null;
            }
            return Date.valueOf(fecha);
        } catch (DateTimeParseException e) {
            errores.put("txtFechaNac", "Ingrese una fecha de nacimiento valida.");
            return null;
        }
    }

    private Integer resolverRol(String valor) {
        Integer id = convertirEntero(valor);
        return id != null ? id : new RolDAO().obtenerIdPorDescripcion(valor);
    }

    private Integer resolverRolPaciente() {
        Integer id = new RolDAO().obtenerIdPorDescripcion("Paciente");
        if (id != null) {
            return id;
        }
        id = new RolDAO().obtenerIdPorDescripcion("Paciente.");
        if (id != null) {
            return id;
        }
        Rol rol = new RolDAO().consultaRol(3);
        return rol != null && rol.getdescripcion_rol() != null
                && rol.getdescripcion_rol().trim().toLowerCase().startsWith("paciente") ? 3 : null;
    }

    private boolean esRolPaciente(Integer idRol, String valorRol) {
        if ("Paciente".equalsIgnoreCase(valorRol)) {
            return true;
        }
        if (idRol == null) {
            return false;
        }

        Rol rol = new RolDAO().consultaRol(idRol);
        return rol != null && rol.getdescripcion_rol() != null
                && rol.getdescripcion_rol().trim().equalsIgnoreCase("Paciente");
    }

    private Integer resolverTipoDocumento(String valor) {
        Integer id = convertirEntero(valor);
        return id != null ? id : new Tipo_documentoDAO().obtenerIdPorDescripcion(valor);
    }

    private Integer convertirEntero(String valor) {
        try {
            return valor.isEmpty() ? null : Integer.valueOf(valor);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void responderConErrores(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> errores, Map<String, String> valores) throws ServletException, IOException {
        cargarSelectores(request);
        request.setAttribute("errores", errores);
        request.setAttribute("valores", valores);
        request.setAttribute("mensajeError", "Revise los campos marcados y vuelva a intentarlo.");
        request.getRequestDispatcher(VISTA_REGISTRO).forward(request, response);
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private String redireccionConParametro(String redireccion, String clave, String valor) {
        return redireccion + (redireccion.contains("?") ? "&" : "?") + clave + "=" + valor;
    }

    private boolean esAdministrador(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            return false;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        String rol = usuario.getDescripcionRol() == null ? "" : usuario.getDescripcionRol().trim();
        return rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrador.");
    }
}
