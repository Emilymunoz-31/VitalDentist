<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@page import="Modelo.Usuario"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-page admin-module-page">
    <nav class="navbar navbar-dark bg-primary shadow-sm sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold text-decoration-none" href="${pageContext.request.contextPath}/AdminInicioServlet">VitalDentist Administrador</a>
            <a href="${pageContext.request.contextPath}/Vista/Login.jsp" class="btn btn-outline-light btn-sm">Cerrar Sesion</a>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 dashboard-sidebar p-3 shadow-sm d-none d-md-block">
                <div class="px-2 mb-4">
                    <p class="admin-eyebrow mb-1">Menu</p>
                    <h5 class="text-primary fw-bold mb-0">Gestion clinica</h5>
                </div>
                <div class="accordion accordion-flush" id="menuAdministrador">
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuAdministracion">Administracion</button>
                        </h2>
                        <div id="menuAdministracion" class="accordion-collapse collapse" data-bs-parent="#menuAdministrador">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroUsuarioServlet">Usuarios</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroRolServlet">Roles</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroTipoDocumentoServlet">Tipos documento</a>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuCitas">Citas</button>
                        </h2>
                        <div id="menuCitas" class="accordion-collapse collapse" data-bs-parent="#menuAdministrador">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">Programar cita</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroEstadoCitaServlet">Estados de cita</a>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuTratamientos">Tratamientos</button>
                        </h2>
                        <div id="menuTratamientos" class="accordion-collapse collapse" data-bs-parent="#menuAdministrador">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet">Categorias</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">Tratamientos</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroHistorialTratamientoServlet">Historial</a>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuPagos">Pagos</button>
                        </h2>
                        <div id="menuPagos" class="accordion-collapse collapse" data-bs-parent="#menuAdministrador">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet">Pagos</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet">Abonos</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroEstadoPagoServlet">Estados de pago</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroMedioPagoServlet">Medios de pago</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>

            <main class="col-md-9 col-lg-10 p-4">
                <div class="admin-module-header">
                    <div>
                        <p class="admin-eyebrow">Dashboard administrativo</p>
                        <h1 class="h3 text-primary fw-bold mb-1">Panel de control clinico</h1>
                        <p class="text-muted mb-0">Acceso rapido a citas, pacientes, tratamientos y pagos.</p>
                    </div>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/AgendarCitaServlet">Agendar cita</a>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-4">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Pacientes registrados</p>
                            <h2 class="h4 fw-bold mb-2">Gestion de usuarios</h2>
                            <a href="${pageContext.request.contextPath}/RegistroUsuarioServlet" class="btn btn-outline-primary btn-sm">Ver usuarios</a>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-4">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Citas del dia</p>
                            <h2 class="h4 fw-bold mb-2">Agenda clinica</h2>
                            <a href="${pageContext.request.contextPath}/AgendarCitaServlet" class="btn btn-outline-primary btn-sm">Programar cita</a>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-4">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Tratamientos</p>
                            <h2 class="h4 fw-bold mb-2">Catalogo clinico</h2>
                            <a href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet" class="btn btn-outline-primary btn-sm">Ver tratamientos</a>
                        </div>
                    </div>
                </div>

                <section class="card admin-card">
                    <div class="card-header admin-card-header">
                        <h2 class="h5 mb-0">Cronograma de citas</h2>
                        <small>Agenda registrada para seguimiento administrativo.</small>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Fecha y hora</th>
                                        <th>Observacion</th>
                                        <th>Paciente</th>
                                        <th>Tratamiento</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cita" items="${citas}">
                                        <tr>
                                            <td>${cita.fecha_hora}</td>
                                            <td>${empty cita.descripcion_cita ? 'Sin observacion' : cita.descripcion_cita}</td>
                                            <td>${empty cita.nombrePaciente ? 'Paciente registrado' : cita.nombrePaciente}</td>
                                            <td>${empty cita.descripcionTratamiento ? 'Tratamiento asignado' : cita.descripcionTratamiento}</td>
                                            <td><span class="badge text-bg-info">${empty cita.descripcionEstadoCita ? 'Estado registrado' : cita.descripcionEstadoCita}</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty citas}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">No hay citas registradas todavia.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

