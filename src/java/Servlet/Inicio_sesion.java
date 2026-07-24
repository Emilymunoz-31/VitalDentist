package Servlet;

import Controlador.UsuarioDAO;
import Modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import java.io.IOException;

@WebServlet(name = "Servlet.Inicio_sesion", urlPatterns = {"/Inicio_sesion"})
public class Inicio_sesion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Vista/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String documento = request.getParameter("documento");
    String contrasena = request.getParameter("contrasena");

    UsuarioDAO dao = new UsuarioDAO();
    
    Usuario usuario = dao.validar(documento, contrasena);

    if (usuario != null && usuario.getDocumento() != null) {
    HttpSession session = request.getSession();
    session.setAttribute("usuarioLogueado", usuario); 
    String rol = usuario.getDescripcionRol() == null ? "" : usuario.getDescripcionRol().trim();
    if (rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrador.")) {
        response.sendRedirect(request.getContextPath() + "/AdminInicioServlet");
    } else if (rol.equalsIgnoreCase("Odontologo") || rol.equalsIgnoreCase("Odontologo.")) {
        response.sendRedirect(request.getContextPath() + "/Vista/odontologo_inicio.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/Vista/inicio.jsp");
    }

        
    } else {
        request.setAttribute("error", "Credenciales incorrectas. El documento o la contraseña no coinciden.");
        request.getRequestDispatcher("Vista/Login.jsp").forward(request, response);
    }
}
}

