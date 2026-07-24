<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>VitalDentist - Odontologo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-page admin-module-page">
    <nav class="navbar navbar-dark bg-primary shadow-sm sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold text-decoration-none" href="${pageContext.request.contextPath}/Vista/odontologo_inicio.jsp">VitalDentist Odontologo</a>
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
                <div class="accordion accordion-flush" id="menuOdontologo">
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuCitasOdontologo">Citas</button>
                        </h2>
                        <div id="menuCitasOdontologo" class="accordion-collapse collapse show" data-bs-parent="#menuOdontologo">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">Registrar cita</a>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuPagosOdontologo">Pagos</button>
                        </h2>
                        <div id="menuPagosOdontologo" class="accordion-collapse collapse" data-bs-parent="#menuOdontologo">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet">Pagos</a>
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet">Abonos</a>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent px-2 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#menuTratamientosOdontologo">Tratamientos</button>
                        </h2>
                        <div id="menuTratamientosOdontologo" class="accordion-collapse collapse" data-bs-parent="#menuOdontologo">
                            <div class="accordion-body p-0">
                                <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">Tratamientos</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>

            <main class="col-md-9 col-lg-10 p-4">
                <div class="admin-module-header">
                    <div>
                        <p class="admin-eyebrow">Panel odontologico</p>
                        <h1 class="h3 text-primary fw-bold mb-1">Gestion clinica</h1>
                        <p class="text-muted mb-0">Acceso rapido a citas, pagos, abonos y tratamientos.</p>
                    </div>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/AgendarCitaServlet">Registrar cita</a>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Agenda</p>
                            <h2 class="h5 fw-bold mb-2">Registrar cita</h2>
                            <a href="${pageContext.request.contextPath}/AgendarCitaServlet" class="btn btn-outline-primary btn-sm">Abrir</a>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Caja</p>
                            <h2 class="h5 fw-bold mb-2">Pagos</h2>
                            <a href="${pageContext.request.contextPath}/RegistroPagoServlet" class="btn btn-outline-primary btn-sm">Abrir</a>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Seguimiento</p>
                            <h2 class="h5 fw-bold mb-2">Abonos</h2>
                            <a href="${pageContext.request.contextPath}/RegistroAbonoServlet" class="btn btn-outline-primary btn-sm">Abrir</a>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card compact-stat">
                            <p class="text-muted small mb-1">Catalogo</p>
                            <h2 class="h5 fw-bold mb-2">Tratamientos</h2>
                            <a href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet" class="btn btn-outline-primary btn-sm">Abrir</a>
                        </div>
                    </div>
                </div>

                <section class="card admin-card">
                    <div class="card-header admin-card-header">
                        <h2 class="h5 mb-0">Opciones disponibles</h2>
                        <small>Interfaz limitada para gestion odontologica.</small>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6 col-xl-3"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/AgendarCitaServlet">Registrar cita</a></div>
                            <div class="col-md-6 col-xl-3"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/RegistroPagoServlet">Pagos</a></div>
                            <div class="col-md-6 col-xl-3"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/RegistroAbonoServlet">Abonos</a></div>
                            <div class="col-md-6 col-xl-3"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">Tratamientos</a></div>
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
