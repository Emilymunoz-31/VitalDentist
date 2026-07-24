<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagos - VitalDentist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="registration-page admin-module-page">
<main class="container py-5">
    <div class="admin-back-row">
        <a class="btn btn-outline-primary" href="${ctx}/AdminInicioServlet">Volver al Inicio</a>
    </div>
    <div class="admin-module-header mb-4">
        <div>
            <p class="admin-eyebrow text-muted fw-bold small text-uppercase mb-1">Modulo administrativo</p>
            <h1 class="h3 text-primary fw-bold mb-0">Gestionar pagos</h1>
        </div>
    </div>

    <c:if test="${param.mensaje == 'guardado'}"><div class="alert transaction-alert">Registro guardado correctamente.</div></c:if>
    <c:if test="${param.mensaje == 'eliminado'}"><div class="alert transaction-alert">Registro eliminado correctamente.</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger">No fue posible completar la operacion.</div></c:if>

    <div class="row g-4">
        <div class="col-lg-4">
            <form action="${ctx}/RegistroPagoServlet" method="POST" class="needs-validation admin-card card shadow-sm p-4 border-0" novalidate>
                <input type="hidden" name="accion" value="${empty pagoEditar ? 'insertar' : 'actualizar'}">
                <input type="hidden" name="id" value="${pagoEditar.id_Pago}">
                
                <h5 class="text-primary fw-bold mb-3 border-bottom pb-2">Detalles del Pago</h5>
                
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">1. Seleccionar Cita</label>
                        <select name="cita" class="form-select" required>
                            <option value="">Seleccione la cita...</option>
                            <c:forEach var="cita" items="${citas}">
                                <option value="${cita.id_Cita}" ${pagoEditar.cita_id_Cita == cita.id_Cita ? 'selected' : ''}>
                                    ${cita.fecha_hora} | ${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente} (${empty cita.descripcionTratamiento ? 'Tratamiento' : cita.descripcionTratamiento})
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Debe seleccionar una cita.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">2. Monto a Pagar</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">$</span>
                            <input type="number" step="0.01" min="1" name="monto" class="form-control" value="${pagoEditar.monto}" placeholder="Ej. 50000" required>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">3. Medio de pago</label>
                        <select name="medioPago" class="form-select" required>
                            <option value="">Seleccione...</option>
                            <c:forEach var="medio" items="${mediosPago}">
                                <option value="${medio.id_Mediopago}" ${pagoEditar.medio_pago_id_Mediopago == medio.id_Mediopago ? 'selected' : ''}>${medio.descripcion_mediopa}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">4. Estado del Pago</label>
                        <select name="estadoPago" class="form-select" required>
                            <option value="">Seleccione...</option>
                            <c:forEach var="estado" items="${estadosPago}">
                                <option value="${estado.id_Estadopago}" ${pagoEditar.estado_pago_id_Estadopago == estado.id_Estadopago ? 'selected' : ''}>${estado.descripcion_estadop}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12 d-flex gap-2 mt-4">
                        <button class="btn btn-primary w-100 fw-bold" type="submit">${empty pagoEditar ? 'Registrar Pago' : 'Actualizar Pago'}</button>
                        <c:if test="${not empty pagoEditar}">
                            <a class="btn btn-outline-secondary w-100" href="${ctx}/RegistroPagoServlet">Cancelar</a>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>
        
        <div class="col-lg-8">
            <section class="card admin-card border-0 shadow-sm">
                <div class="card-header admin-card-header bg-white border-bottom">
                    <h2 class="h5 mb-0 text-primary fw-bold">Historial de Pagos</h2>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Monto</th>
                                    <th>Medio</th>
                                    <th>Estado</th>
                                    <th>Cita (ID)</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pago" items="${pagos}">
                                    <tr>
                                        <td class="fw-semibold text-success">$ ${pago.monto}</td>
                                        <td>${empty pago.descripcionMedioPago ? 'No definido' : pago.descripcionMedioPago}</td>
                                        <td>
                                            <span class="badge ${pago.descripcionEstadoPago == 'Pagado' ? 'text-bg-success' : 'text-bg-warning'}">
                                                ${empty pago.descripcionEstadoPago ? 'Pendiente' : pago.descripcionEstadoPago}
                                            </span>
                                        </td>
                                        <td>Cita #${pago.cita_id_Cita}</td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="${ctx}/RegistroPagoServlet?accion=editar&id=${pago.id_Pago}">Editar</a> 
                                            <a class="btn btn-sm btn-outline-danger" href="${ctx}/RegistroPagoServlet?accion=eliminar&id=${pago.id_Pago}" onclick="return confirm('¿Desea eliminar este registro de pago?')">Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pagos}">
                                    <tr><td colspan="5" class="text-center text-muted py-4">No hay pagos registrados aún.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
</body>
</html>

