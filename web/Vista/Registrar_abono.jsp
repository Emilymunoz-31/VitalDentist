<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Abonos - VitalDentist</title>
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
            <h1 class="h3 text-primary fw-bold mb-0">Gestionar abonos</h1>
        </div>
    </div>

    <c:if test="${param.mensaje == 'guardado'}"><div class="alert transaction-alert">Registro guardado correctamente.</div></c:if>
    <c:if test="${param.mensaje == 'eliminado'}"><div class="alert transaction-alert">Registro eliminado correctamente.</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger">No fue posible completar la operacion.</div></c:if>

    <div class="row g-4">
        <div class="col-lg-4">
            <form action="${ctx}/RegistroAbonoServlet" method="POST" class="needs-validation admin-card card shadow-sm p-4 border-0" novalidate>
                <input type="hidden" name="accion" value="${empty abonoEditar ? 'insertar' : 'actualizar'}">
                <input type="hidden" name="id" value="${abonoEditar.id_Abono}">
                
                <h5 class="text-primary fw-bold mb-3 border-bottom pb-2">Registrar Nuevo Abono</h5>

                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">1. Cuenta a abonar (Pago)</label>
                        <select name="pago" class="form-select" required>
                            <option value="">Seleccione el pago...</option>
                            <c:forEach var="pago" items="${pagos}">
                                <c:set var="isSelected" value="${(abonoEditar.pago_id_Pago == pago.id_Pago) or (param.idPago == pago.id_Pago) ? 'selected' : ''}" />
                                <option value="${pago.id_Pago}" ${isSelected}>
                                    Pago #${pago.id_Pago} - Costo Total: $${pago.monto}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Seleccione la cuenta a la cual abonará.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">2. Monto del Abono</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">$</span>
                            <input type="number" step="0.01" min="1" name="monto" class="form-control" value="${abonoEditar.monto_abono}" placeholder="Ej. 20000" required>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">3. Fecha del Abono</label>
                        <input type="date" name="fecha" class="form-control" value="${abonoEditar.fecha_abono}" required>
                    </div>

                    <div class="col-12 d-flex gap-2 mt-4">
                        <button class="btn btn-primary w-100 fw-bold" type="submit">${empty abonoEditar ? 'Guardar Abono' : 'Actualizar Abono'}</button>
                        <c:if test="${not empty abonoEditar}">
                            <a class="btn btn-outline-secondary w-100" href="${ctx}/RegistroAbonoServlet">Cancelar</a>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>
        
        <div class="col-lg-8">
            <section class="card admin-card border-0 shadow-sm">
                <div class="card-header admin-card-header bg-white border-bottom">
                    <h2 class="h5 mb-0 text-primary fw-bold">Abonos registrados</h2>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha</th>
                                    <th>Abono</th>
                                    <th>ID Pago Asignado</th>
                                    <th class="text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="abono" items="${abonos}">
                                    <tr>
                                        <td>${abono.fecha_abono}</td>
                                        <td class="fw-bold text-success">$ ${abono.monto_abono}</td>
                                        <td><span class="badge text-bg-secondary">Pago #${abono.pago_id_Pago}</span></td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="${ctx}/RegistroAbonoServlet?accion=editar&id=${abono.id_Abono}">Editar</a> 
                                            <a class="btn btn-sm btn-outline-danger" href="${ctx}/RegistroAbonoServlet?accion=eliminar&id=${abono.id_Abono}" onclick="return confirm('¿Desea eliminar este abono? El saldo de la cuenta cambiará.')">Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty abonos}">
                                    <tr><td colspan="4" class="text-center text-muted py-4">No hay abonos registrados.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
</body>
</html>
