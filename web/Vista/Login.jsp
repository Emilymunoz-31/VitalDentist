<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Iniciar Sesion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css?v=2"></head>
<body class="bg-light d-flex align-items-center login-page">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-6 col-lg-4">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-body p-5">
                    
                    <div class="text-center mb-4">
                        <h2 class="fw-bold color-primario">VitalDentist</h2>
                        <p class="text-muted">Bienvenido de nuevo</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center alert-dismissible fade show" role="alert">
                            <small>${error}</small>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form id="loginForm" action="${ctx}/Inicio_sesion" method="POST" class="needs-validation">
                        
                        <div class="mb-3">
                            <label for="documento" class="form-label fw-semibold">Numero de Documento</label>
                            <input type="text" class="form-control" id="documento" name="documento" 
                                   placeholder="ej: 102367967" required pattern="[0-9]+">
                        </div>

                        <div class="mb-3">
                            <label for="contrasena" class="form-label fw-semibold">Contraseña</label>
                            <input type="password" class="form-control" id="contrasena" name="contrasena" 
                                   placeholder="********" required>
                        </div>

                        <div class="mb-4 text-end">
                            <a href="${ctx}/Vista/Recuperar_contrasena.jsp" class="text-decoration-none small text-secondary hover-primary">Olvidaste tu contraseña?</a>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary rounded-pill">Ingresar</button>
                        </div>
                    </form>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
</body>
</html>



