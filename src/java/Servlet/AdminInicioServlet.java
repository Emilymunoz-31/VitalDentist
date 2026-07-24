package Servlet;

import Controlador.CitaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminInicioServlet", urlPatterns = {"/AdminInicioServlet"})
public class AdminInicioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("citas", new CitaDAO().listarCitas());
        request.getRequestDispatcher("/Vista/admin_inicio.jsp").forward(request, response);
    }
}
