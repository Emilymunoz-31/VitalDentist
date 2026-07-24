<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Recuperar Contraseña</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="login-page d-flex align-items-center min-vh-100 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        
                        <div class="text-center mb-4">
                            <h2 class="fw-bold color-primario mb-2">Recuperar Contraseña</h2>
                            <p class="text-muted small mb-0">Ingresa tu correo registrado para enviarte el código de verificación.</p>
                        </div>

                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-info alert-dismissible fade show small text-center" role="alert">
                                <strong>${mensaje}</strong>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form id="formRecuperar" action="${ctx}/Recuperar_clave" method="POST" class="needs-validation" novalidate>
                            
                            <div class="mb-3">
                                <label for="correo" class="form-label fw-semibold">Correo Electrónico</label>
                                <input type="email" id="correo" name="correo" class="form-control" placeholder="ejemplo@correo.com" required>
                                <div class="invalid-feedback">Ingresa un correo válido.</div>
                            </div>

                            <div class="alert alert-light border small mb-4">
                                🔒 Te enviaremos un código temporal a tu bandeja de entrada.
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" id="btnEnviar" class="btn btn-primary fw-semibold py-2">
                                    <span id="btnText">Enviar Correo</span>
                                    <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                </button>
                                <a href="${ctx}/Vista/Login.jsp" class="btn btn-outline-secondary py-2">Volver al Login</a>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animación de Carga al Enviar
        const form = document.getElementById('formRecuperar');
        const btnEnviar = document.getElementById('btnEnviar');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');

        form.addEventListener('submit', function (e) {
            if (form.checkValidity()) {
                btnEnviar.disabled = true;
                btnText.textContent = "Enviando correo...";
                btnSpinner.classList.remove('d-none');
            } else {
                form.classList.add('was-validated');
                e.preventDefault();
            }
        });
    </script>
</body>
</html>