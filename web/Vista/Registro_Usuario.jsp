<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Registro de Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="registration-page admin-module-page">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="admin-back-row"><a href="${ctx}/AdminInicioServlet" class="btn btn-outline-primary">Volver al Inicio</a></div><div class="admin-module-header"><div><p class="admin-eyebrow">Modulo administrativo</p><h1 class="h3 text-primary fw-bold mb-0">Registrar Usuario</h1></div></div>
            <div class="card card-registration shadow-lg">
                <div class="card-body p-4 p-md-5">
                    <h2 class="h5 mb-2 fw-bold text-primary">Informacion del usuario</h2>
                    <p class="text-muted mb-4">Complete los campos obligatorios para dar de alta a un nuevo miembro del equipo.</p>

                    <c:if test="${not empty mensajeExito}">
                        <div class="alert transaction-alert alert-dismissible fade show" role="alert">
                            <strong>Transaccion exitosa.</strong>
                            ${mensajeExito} El registro quedo guardado y puede ingresar otro usuario si lo necesita.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty mensajeError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${mensajeError}
                            <c:if test="${not empty errores.general}">
                                <div class="small mt-1">${errores.general}</div>
                            </c:if>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                        </div>
                    </c:if>

                    <c:if test="${empty roles or empty tiposDocumento}">
                        <div class="alert alert-warning" role="alert">
                            No se pudieron cargar roles o tipos de documento desde la base de datos.
                        </div>
                    </c:if>

                    <form id="registroUsuarioForm" action="${ctx}/RegistroUsuarioServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty usuarioEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${usuarioEditar.id_Usuario}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtNombres" class="form-label fw-semibold">Nombres</label>
                                <input type="text" id="txtNombres" name="txtNombres"
                                       class="form-control ${not empty errores.txtNombres ? 'is-invalid' : ''}"
                                       value="${valores.txtNombres}" placeholder="Ej: Juan Camilo" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtNombres}" default="Ingrese los nombres." />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="txtApellidos" class="form-label fw-semibold">Apellidos</label>
                                <input type="text" id="txtApellidos" name="txtApellidos"
                                       class="form-control ${not empty errores.txtApellidos ? 'is-invalid' : ''}"
                                       value="${valores.txtApellidos}" placeholder="Ej: Perez Rodriguez" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtApellidos}" default="Ingrese los apellidos." />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtTipoDoc" class="form-label fw-semibold">Tipo de Documento</label>
                                <select id="txtTipoDoc" name="txtTipoDoc"
                                        class="form-select ${not empty errores.txtTipoDoc ? 'is-invalid' : ''}" required>
                                    <option value="">Seleccione...</option>
                                    <c:forEach var="tipo" items="${tiposDocumento}">
                                        <option value="${tipo.id_Tipodocumento}" ${valores.txtTipoDoc == tipo.id_Tipodocumento ? 'selected' : ''}>
                                            ${tipo.descripcion_tipodoc}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtTipoDoc}" default="Seleccione un tipo de documento." />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="txtDocumento" class="form-label fw-semibold">Numero de Documento</label>
                                <input type="text" id="txtDocumento" name="txtDocumento" inputmode="numeric"
                                       class="form-control ${not empty errores.txtDocumento ? 'is-invalid' : ''}"
                                       value="${valores.txtDocumento}" placeholder="12345678" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtDocumento}" default="Ingrese el numero de documento." />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtFechaNac" class="form-label fw-semibold">Fecha de Nacimiento</label>
                                <input type="date" id="txtFechaNac" name="txtFechaNac"
                                       class="form-control ${not empty errores.txtFechaNac ? 'is-invalid' : ''}"
                                       value="${valores.txtFechaNac}" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtFechaNac}" default="Seleccione la fecha de nacimiento." />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="txtRol" class="form-label fw-semibold">Rol en la Clinica</label>
                                <select id="txtRol" name="txtRol"
                                        class="form-select ${not empty errores.txtRol ? 'is-invalid' : ''}" required>
                                    <option value="">Seleccione un rol...</option>
                                    <c:forEach var="rol" items="${roles}">
                                        <option value="${rol.id_Rol}" ${valores.txtRol == rol.id_Rol ? 'selected' : ''}>
                                            ${rol.descripcion_rol}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtRol}" default="Seleccione un rol." />
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtCorreo" class="form-label fw-semibold">Correo Electronico</label>
                                <input type="email" id="txtCorreo" name="txtCorreo"
                                       class="form-control ${not empty errores.txtCorreo ? 'is-invalid' : ''}"
                                       value="${valores.txtCorreo}" placeholder="usuario@vitaldentist.com" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtCorreo}" default="Ingrese un correo valido." />
                                </div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="txtTelefono" class="form-label fw-semibold">Telefono</label>
                                <input type="text" id="txtTelefono" name="txtTelefono" inputmode="numeric"
                                       class="form-control ${not empty errores.txtTelefono ? 'is-invalid' : ''}"
                                       value="${valores.txtTelefono}" placeholder="3001234567" required>
                                <div class="invalid-feedback">
                                    <c:out value="${errores.txtTelefono}" default="Ingrese un telefono valido." />
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="txtPassword" class="form-label fw-semibold">Contraseña Temporal</label>
                            <input type="password" id="txtPassword" name="txtPassword"
                                   class="form-control ${not empty errores.txtPassword ? 'is-invalid' : ''}"
                                   value="${valores.txtPassword}" required>
                            <div class="invalid-feedback">
                                <c:out value="${errores.txtPassword}" default="Ingrese una contraseña temporal." />
                            </div>
                        </div>

                        <div class="form-check mb-4">
                            <input type="checkbox" id="tratamientoDatos" name="tratamientoDatos"
                                   class="form-check-input ${not empty errores.tratamientoDatos ? 'is-invalid' : ''}" ${not empty usuarioEditar ? 'checked' : ''} required>
                            <label for="tratamientoDatos" class="form-check-label">
                                Acepto el tratamiento de datos personales.
                            </label>
                            <div class="invalid-feedback">
                                <c:out value="${errores.tratamientoDatos}" default="Debe aceptar el tratamiento de datos." />
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-primary btn-register fw-bold shadow-sm">${empty usuarioEditar ? 'Guardar Usuario' : 'Actualizar Usuario'}</button>
                            <c:if test="${not empty usuarioEditar}"><a class="btn btn-outline-secondary" href="${ctx}/RegistroUsuarioServlet">Cancelar</a></c:if>
                        </div>
                    </form>
                </div>
            </div>

            <section class="card admin-card mt-4">
                <div class="card-header admin-card-header">
                    <h2 class="h5 mb-0">Usuarios registrados</h2>
                    <small>Administradores, odontologos y pacientes visibles para el administrador.</small>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Documento</th>
                                    <th>Telefono</th>
                                    <th>Correo</th>
                                    <th>Rol</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="usuario" items="${usuarios}">
                                    <tr>
                                        <td>${usuario.nombreus} ${usuario.apellido}</td>
                                        <td>${usuario.documento}</td>
                                        <td>${empty usuario.telefono ? 'Sin telefono' : usuario.telefono}</td>
                                        <td>${empty usuario.correo ? 'Sin correo' : usuario.correo}</td>
                                        <td><span class="badge text-bg-light border">${empty usuario.descripcionRol ? 'Sin rol' : usuario.descripcionRol}</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="${ctx}/RegistroUsuarioServlet?accion=editar&id=${usuario.id_Usuario}">Editar</a>
                                            <a class="btn btn-sm btn-outline-danger" href="${ctx}/RegistroUsuarioServlet?accion=eliminar&id=${usuario.id_Usuario}" onclick="return confirm('Desea eliminar este usuario?')">Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty usuarios}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">No hay usuarios registrados.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        <c:if test="${not empty mensajeExito}">
            Swal.fire({
                title: 'Transaccion exitosa',
                html: '<strong>Usuario registrado.</strong><br>${mensajeExito}<br>Puede registrar otro usuario con seguridad.',
                icon: 'success',
                customClass: {
                    popup: 'vital-transaction-popup',
                    confirmButton: 'vital-confirm-button'
                },
                confirmButtonText: 'Registrar otro'
            });
        </c:if>

        <c:if test="${not empty mensajeError}">
            Swal.fire({
                title: 'Transaccion declinada',
                text: '${mensajeError}',
                icon: 'error',
                customClass: { popup: 'vital-transaction-popup', confirmButton: 'vital-confirm-button' },
                confirmButtonText: 'Revisar'
            });
        </c:if>
    });
</script>
</body>
</html>







