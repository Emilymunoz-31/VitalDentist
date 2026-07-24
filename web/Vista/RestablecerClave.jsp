<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Restablecer Contraseña</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="login-page d-flex align-items-center justify-content-center min-vh-100">

    <div class="container d-flex justify-content-center">
        <div class="otp-wrapper-center w-100" style="max-width: 420px;">
            <div class="otp-Form shadow-lg p-4 p-md-5 bg-white rounded-4 position-relative w-100">
                <a href="${ctx}/Vista/Login.jsp" class="exitBtn" title="Cancelar">×</a>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-info alert-dismissible fade show w-100 p-2 small text-center mb-3" role="alert">
                        ${mensaje}
                        <button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not pasoDosCompleto}">
                    <div class="text-center mb-4">
                        <span class="mainHeading h4 fw-bold text-primary d-block mb-1">Verificación OTP</span>
                        <p class="otpSubheading text-muted small">Ingresa el código de 4 caracteres enviado a tu correo.</p>
                    </div>

                    <form id="formPaso1" action="${ctx}/RestablecerClave" method="POST" class="w-100 d-flex flex-column align-items-center gap-3">
                        <input type="hidden" name="accion" value="validarCodigo">
                        <input type="hidden" name="correo" value="${correoPrecargado}">
                        <input type="hidden" id="codigoCompleto" name="codigo" value="">

                        <div class="inputContainer d-flex justify-content-center gap-2 w-100 my-2">
                            <input required maxlength="1" type="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input1" autofocus />
                            <input required maxlength="1" type="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input2" />
                            <input required maxlength="1" type="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input3" />
                            <input required maxlength="1" type="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input4" />
                        </div>

                        <button class="verifyButton btn btn-primary w-100 py-2 fw-bold shadow-sm" type="submit" id="btnValidar">
                            <span id="btnText1">Verificar</span>
                            <span id="btnSpinner1" class="spinner-border spinner-border-sm d-none" role="status"></span>
                        </button>
                    </form>

                    <div class="resendNote text-center mt-3">
                        <span class="text-muted small">¿No recibiste el código?</span>
                        <form action="${ctx}/Recuperar_clave" method="POST" class="d-inline ms-1">
                            <input type="hidden" name="correo" value="${correoPrecargado}">
                            <button type="submit" class="resendBtn btn btn-link p-0 fw-bold text-decoration-none">Reenviar código</button>
                        </form>
                    </div>
                </c:if>

                <c:if test="${pasoDosCompleto}">
                    <div class="text-center mb-4">
                        <span class="mainHeading h4 fw-bold text-primary d-block mb-1">Nueva Contraseña</span>
                        <p class="otpSubheading text-muted small">Crea y confirma tu nueva clave de acceso.</p>
                    </div>

                    <form id="formPaso2" action="${ctx}/RestablecerClave" method="POST" class="w-100 d-flex flex-column gap-3 text-start">
                        <input type="hidden" name="accion" value="cambiarClave">
                        <input type="hidden" name="correo" value="${correoPrecargado}">

                        <div>
                            <label for="nuevaClave" class="form-label mb-1 text-muted fw-semibold small">Nueva Clave</label>
                            <input type="password" id="nuevaClave" name="nuevaClave" class="input-pass-vital form-control" placeholder="Mínimo 6 caracteres" minlength="6" required>
                        </div>

                        <div>
                            <label for="confirmarClave" class="form-label mb-1 text-muted fw-semibold small">Confirmar Clave</label>
                            <input type="password" id="confirmarClave" name="confirmarClave" class="input-pass-vital form-control" placeholder="Repite la clave" minlength="6" required>
                        </div>

                        <button type="button" class="verifyButton btn btn-primary w-100 py-2 fw-bold shadow-sm mt-2" onclick="abrirModalConfirmacion()">
                            Guardar Clave
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalConfirmar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold color-primario fs-6">Confirmar Cambio</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-muted small py-3 text-center">
                    ¿Estás seguro de que deseas actualizar tu contraseña?
                </div>
                <div class="modal-footer border-0 justify-content-center pt-0">
                    <button type="button" class="btn btn-light btn-sm px-3 fw-semibold rounded-pill" data-bs-dismiss="modal">Revisar</button>
                    <button type="button" id="btnConfirmarFinal" class="btn btn-primary btn-sm px-3 fw-semibold rounded-pill" onclick="ejecutarCambio()">
                        <span id="btnText2">Sí, Guardar</span>
                        <span id="btnSpinner2" class="spinner-border spinner-border-sm d-none" role="status"></span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const formPaso1 = document.getElementById('formPaso1');

        if (inputs.length > 0) {
            inputs.forEach((input, index) => {
                input.addEventListener('keyup', (e) => {
                    if (input.value.length === 1 && index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                    if (e.key === 'Backspace' && index > 0 && input.value === '') {
                        inputs[index - 1].focus();
                    }
                });
            });

            formPaso1.addEventListener('submit', function (e) {
                let codigo = '';
                inputs.forEach(input => codigo += input.value.toUpperCase());
                document.getElementById('codigoCompleto').value = codigo;

                document.getElementById('btnText1').textContent = "Verificando...";
                document.getElementById('btnSpinner1').classList.remove('d-none');
            });
        }

        let modalConfirm;
        function abrirModalConfirmacion() {
            const clave1 = document.getElementById('nuevaClave').value;
            const clave2 = document.getElementById('confirmarClave').value;

            if (!clave1 || !clave2) {
                alert("Por favor, llena ambos campos de contraseña.");
                return;
            }
            if (clave1.length < 6) {
                alert("La contraseña debe tener mínimo 6 caracteres.");
                return;
            }
            if (clave1 !== clave2) {
                alert("Las contraseñas no coinciden.");
                return;
            }

            modalConfirm = new bootstrap.Modal(document.getElementById('modalConfirmar'));
            modalConfirm.show();
        }

        function ejecutarCambio() {
            document.getElementById('btnConfirmarFinal').disabled = true;
            document.getElementById('btnText2').textContent = "Guardando...";
            document.getElementById('btnSpinner2').classList.remove('d-none');
            document.getElementById('formPaso2').submit();
        }
    </script>
</body>
</html>