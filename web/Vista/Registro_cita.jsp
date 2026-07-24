<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Programar Cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="appointment-page admin-module-page" style="overflow-y: auto !important; height: auto !important;">

<main class="container py-4 py-lg-5" style="overflow-y: visible !important; height: auto !important; min-height: 100vh;">    
    <div class="admin-back-row"><a href="${ctx}/AdminInicioServlet" class="btn btn-outline-primary">Volver al Inicio</a></div>
    <div class="admin-module-header mb-4"><div><p class="text-uppercase text-muted fw-bold small mb-1">Gestion de citas</p><h1 class="h3 text-primary fw-bold mb-1">Programar nueva cita</h1><p class="text-muted mb-0">Seleccione el paciente y defina la informacion de la cita.</p></div></div>

    <c:if test="${param.paciente_registrado == '1'}">
        <div class="alert transaction-alert"><strong>Paciente registrado correctamente.</strong> Ya puede buscarlo por nombre o documento.</div>
    </c:if>
    <c:if test="${param.paciente_error == 'datos_invalidos'}">
        <div class="alert alert-danger">No fue posible registrar el paciente. Revise nombres, documento, telefono, correo y aceptacion de datos.</div>
    </c:if>
    <c:if test="${param.paciente_error == 'registro'}">
        <div class="alert alert-danger">No fue posible guardar el paciente. Verifique si el documento o correo ya existen.</div>
    </c:if>
    <c:if test="${param.mensaje == 'cita_creada'}">
        <div class="alert transaction-alert"><strong>Cita registrada.</strong> El pago quedo creado automaticamente en estado pendiente.</div>
    </c:if>
    <c:if test="${param.mensaje == 'actualizado'}">
        <div class="alert transaction-alert"><strong>Cita actualizada.</strong> La agenda se refresco correctamente.</div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div class="alert transaction-alert"><strong>Cita eliminada.</strong> La agenda se refresco correctamente.</div>
    </c:if>
    <c:if test="${param.mensaje == 'cita_creada_pago_config'}">
        <div class="alert alert-warning">La cita fue registrada, pero falta configurar un estado de pago "Pendiente" o un medio de pago en los catalogos.</div>
    </c:if>
    <c:if test="${param.mensaje == 'cita_creada_pago_error'}">
        <div class="alert alert-warning">La cita fue registrada, pero no fue posible crear el pago pendiente.</div>
    </c:if>
    <c:if test="${param.error == 'paciente_no_existe'}">
        <div class="alert alert-danger">Seleccione un paciente valido desde la lista de resultados.</div>
    </c:if>
    <c:if test="${param.error == 'datos_invalidos'}">
        <div class="alert alert-danger">Revise paciente, odontologo, tratamiento, fecha, hora y estado de cita.</div>
    </c:if>
    <c:if test="${param.error == 'no_guardada'}">
        <div class="alert alert-danger">No fue posible guardar la cita. Revise los datos e intentelo nuevamente.</div>
    </c:if>

    <form id="registroCitaForm" action="${ctx}/AgendarCitaServlet" method="POST" class="needs-validation" novalidate>
        <input type="hidden" name="accion" value="${empty citaEditar ? 'insertar' : 'actualizar'}">
        <input type="hidden" name="id" value="${citaEditar.id_Cita}">
        <input type="hidden" id="txtDocumentoCita" name="txtDocumentoCita">

        <section class="card admin-card mb-4 ${empty citaEditar ? '' : 'd-none'}">
            <div class="card-header admin-card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
                <div>
                    <h2 class="h5 mb-0">Informacion del paciente</h2>
                    <small>Busque por nombre o documento y seleccione un resultado.</small>
                </div>
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoPaciente">
                    Registrar Nuevo Paciente
                </button>
            </div>
            <div class="card-body">
                <label for="buscadorPaciente" class="form-label fw-semibold">Buscar paciente</label>
                <div class="position-relative patient-search-wrap">
                    <div class="input-group input-group-lg">
                        <input type="search" id="buscadorPaciente" class="form-control" placeholder="Buscar por nombre o documento..." autocomplete="off" data-busqueda-url="${ctx}/AgendarCitaServlet">
                    </div>
                    <div id="resultadosPaciente" class="patient-results list-group shadow-sm d-none"></div>
                </div>
                <div id="pacienteFeedback" class="form-text text-danger d-none">Seleccione un paciente de la lista antes de guardar.</div>

                <div id="pacienteSeleccionado" class="selected-patient-panel mt-4 d-none">
                    <div class="d-flex flex-wrap gap-2 justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-uppercase text-muted small fw-bold mb-1">Paciente seleccionado</p>
                            <h3 id="pacienteNombreTitulo" class="h5 mb-0 text-primary"></h3>
                        </div>
                        <button type="button" id="limpiarPaciente" class="btn btn-sm btn-outline-secondary">
                            Cambiar
                        </button>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small text-muted">Nombre</label>
                            <input type="text" id="datoNombrePaciente" class="form-control bg-light" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small text-muted">Documento</label>
                            <input type="text" id="datoDocumentoPaciente" class="form-control bg-light" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small text-muted">Telefono</label>
                            <input type="text" id="datoTelefonoPaciente" class="form-control bg-light" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small text-muted">Correo</label>
                            <input type="text" id="datoCorreoPaciente" class="form-control bg-light" readonly>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="card admin-card mb-4">
            <div class="card-header admin-card-header">
                <h2 class="h5 mb-0">Informacion de la cita</h2>
                <small>Datos clinicos y de agenda.</small>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Odontologo</label>
                        <select name="txtIdOdontologo" class="form-select" required>
                            <option value="" disabled selected>Seleccione un profesional...</option>
                            <c:forEach var="odontologo" items="${odontologos}">
                                <option value="${odontologo.id_Usuario}" ${citaEditar.usuario_id_Usuario == odontologo.id_Usuario ? 'selected' : ''}>${odontologo.nombreus} ${odontologo.apellido}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Seleccione un odontologo.</div>
                    </div>

                    <div class="col-md-6">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Categoría</label>
                                <select id="selectCategoriaTratamiento" class="form-select">
                                    <option value="" selected>Todas...</option>
                                    <c:forEach var="cat" items="${categoriasTratamiento}">
                                        <option value="${cat.id_Categoria}">${cat.nombre_categoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Tratamiento</label>
                                <div class="position-relative">
                                    <input type="search" id="buscadorTratamiento" class="form-control" placeholder="Escriba para buscar..." autocomplete="off" value="${citaEditar.descripcionTratamiento}">
                                    <input type="hidden" id="txtIdTratamiento" name="txtIdTratamiento" value="${citaEditar.tipo_Tratamiento_id_Tipotratam}" required>
                                    <div id="resultadosTratamiento" class="patient-results list-group shadow-sm d-none position-absolute w-100" style="z-index: 1000;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="invalid-feedback">Seleccione un tratamiento válido.</div>
                        <small class="text-muted">Costo estimado: <span id="saldoPendientePreview" class="fw-bold text-primary">$0</span></small>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha</label>
                        <input type="date" name="txtFechaCita" class="form-control" value="${fechaEditar}" required>
                        <div class="invalid-feedback">Seleccione la fecha.</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Hora</label>
                        <input type="time" name="txtHoraCita" class="form-control" value="${horaEditar}" required>
                        <div class="invalid-feedback">Seleccione la hora.</div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Estado de cita</label>
                        <select name="txtEstadoCita" class="form-select" required>
                            <option value="" disabled selected>Seleccione...</option>
                            <c:forEach var="estado" items="${estadosCita}">
                                <option value="${estado.idEstado_cita}" ${citaEditar.estado_cita_idEstado_cita == estado.idEstado_cita ? 'selected' : ''}>${estado.descripcion_estadoci}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Seleccione el estado de la cita.</div>
                    </div>
                </div>
            </div>
        </section>

        <section class="card admin-card mb-4">
            <div class="card-header admin-card-header">
                <h2 class="h5 mb-0">Observaciones</h2>
                <small>Motivo de consulta y comentarios adicionales.</small>
            </div>
            <div class="card-body">
                <label class="form-label fw-semibold">Motivo de consulta / comentarios adicionales</label>
                <textarea name="txtObservaciones" class="form-control" rows="4" placeholder="Ej: Control, dolor, limpieza o valoracion.">${citaEditar.descripcion_cita}</textarea>
            </div>
        </section>

        <div class="d-flex flex-column flex-md-row gap-2 justify-content-end pb-4">
            <a href="${ctx}/AdminInicioServlet" class="btn btn-outline-secondary px-4">Cancelar</a>
            <button type="submit" class="btn btn-primary px-4 shadow-sm">${empty citaEditar ? 'Confirmar cita' : 'Actualizar cita'}</button>
        </div>
    </form>

    <section class="card admin-card mb-4">
        <div class="card-header admin-card-header">
            <h2 class="h5 mb-0">Citas registradas</h2>
            <small>Listado actualizado desde la base de datos.</small>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Fecha y hora</th>
                            <th>Paciente</th>
                            <th>Odontologo</th>
                            <th>Tratamiento</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cita" items="${citas}">
                            <tr>
                                <td>${cita.fecha_hora}</td>
                                <td>${empty cita.nombrePaciente ? 'Paciente registrado' : cita.nombrePaciente}</td>
                                <td>${empty cita.nombreOdontologo ? 'Odontologo registrado' : cita.nombreOdontologo}</td>
                                <td>${empty cita.descripcionTratamiento ? 'Tratamiento asignado' : cita.descripcionTratamiento}</td>
                                <td><span class="badge text-bg-info">${empty cita.descripcionEstadoCita ? 'Estado registrado' : cita.descripcionEstadoCita}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-sm btn-outline-primary" href="${ctx}/AgendarCitaServlet?accion=editar&id=${cita.id_Cita}">Editar</a>
                                    <a class="btn btn-sm btn-outline-danger" href="${ctx}/AgendarCitaServlet?accion=eliminar&id=${cita.id_Cita}" onclick="return confirm('Desea eliminar esta cita?')">Eliminar</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty citas}">
                            <tr><td colspan="6" class="text-center text-muted py-4">No hay citas registradas.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</main>

<div class="modal fade" id="modalNuevoPaciente" tabindex="-1" aria-labelledby="modalNuevoPacienteLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold" id="modalNuevoPacienteLabel">Registro Rapido de Paciente</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form action="${ctx}/RegistroUsuarioServlet" method="POST" class="needs-validation" novalidate>
                    <input type="hidden" name="registroPaciente" value="true">
                    <input type="hidden" name="redireccion" value="/AgendarCitaServlet">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Nombres</label>
                            <input type="text" name="txtNombres" class="form-control" required>
                            <div class="invalid-feedback">Ingrese los nombres.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Apellidos</label>
                            <input type="text" name="txtApellidos" class="form-control" required>
                            <div class="invalid-feedback">Ingrese los apellidos.</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-semibold">Tipo Doc.</label>
                            <select name="txtTipoDoc" class="form-select" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="tipo" items="${tiposDocumento}">
                                    <option value="${tipo.id_Tipodocumento}">${tipo.descripcion_tipodoc}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Seleccione el tipo de documento.</div>
                        </div>
                        <div class="col-md-8 mb-3">
                            <label class="form-label fw-semibold">Numero de Documento</label>
                            <input type="text" name="txtDocumento" class="form-control" inputmode="numeric" required>
                            <div class="invalid-feedback">Ingrese el documento.</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Telefono / Celular</label>
                            <input type="text" name="txtTelefono" class="form-control" inputmode="numeric" required>
                            <div class="invalid-feedback">Ingrese el telefono.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Fecha de Nacimiento</label>
                            <input type="date" name="txtFechaNac" class="form-control" required>
                            <div class="invalid-feedback">Seleccione la fecha de nacimiento.</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Correo Electronico</label>
                        <input type="email" name="txtCorreo" class="form-control" placeholder="paciente@ejemplo.com" required>
                        <div class="invalid-feedback">Ingrese un correo valido.</div>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="tratamientoDatosPaciente" name="tratamientoDatos" class="form-check-input" required>
                        <label for="tratamientoDatosPaciente" class="form-check-label">Acepto el tratamiento de datos personales del paciente.</label>
                        <div class="invalid-feedback">Debe aceptar el tratamiento de datos.</div>
                    </div>
                    <div class="modal-footer px-0 pb-0 mt-3 border-0">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary fw-bold">Guardar Paciente</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById("registroCitaForm");
        const buscador = document.getElementById("buscadorPaciente");
        const documento = document.getElementById("txtDocumentoCita");
        const resultados = document.getElementById("resultadosPaciente");
        const feedback = document.getElementById("pacienteFeedback");
        const panel = document.getElementById("pacienteSeleccionado");
        const saldoPreview = document.getElementById("saldoPendientePreview");
        let temporizador = null;

        function formatoMoneda(valor) {
            return new Intl.NumberFormat("es-CO", { style: "currency", currency: "COP", maximumFractionDigits: 0 }).format(valor || 0);
        }

        function ocultarResultados() {
            resultados.classList.add("d-none");
            resultados.innerHTML = "";
        }

        function seleccionarPaciente(paciente) {
            documento.value = paciente.documento || "";
            buscador.value = (paciente.nombre || "") + " - " + (paciente.documento || "");
            document.getElementById("pacienteNombreTitulo").textContent = paciente.nombre || "Paciente";
            document.getElementById("datoNombrePaciente").value = paciente.nombre || "";
            document.getElementById("datoDocumentoPaciente").value = paciente.documento || "";
            document.getElementById("datoTelefonoPaciente").value = paciente.telefono || "No registrado";
            document.getElementById("datoCorreoPaciente").value = paciente.correo || "No registrado";
            panel.classList.remove("d-none");
            feedback.classList.add("d-none");
            ocultarResultados();
        }

        buscador.addEventListener("input", function() {
            documento.value = "";
            panel.classList.add("d-none");
            clearTimeout(temporizador);
            const termino = buscador.value.trim();
            if (termino.length < 2) {
                ocultarResultados();
                return;
            }

            temporizador = setTimeout(function() {
                const url = buscador.dataset.busquedaUrl + "?accion=buscarPacientes&q=" + encodeURIComponent(termino);
                fetch(url)
                    .then(response => response.ok ? response.json() : [])
                    .then(pacientes => {
                        resultados.innerHTML = "";
                        if (!pacientes.length) {
                            resultados.innerHTML = '<div class="list-group-item py-3"><div class="fw-semibold">Sin resultados</div><small class="text-muted">Puede registrar un nuevo paciente desde el boton superior.</small></div>';
                            resultados.classList.remove("d-none");
                            return;
                        }

                        pacientes.forEach(function(paciente) {
                            const item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action patient-result-item";
                            item.innerHTML = '<span class="fw-semibold">' + paciente.nombre + '</span><small class="d-block text-muted">CC ' + paciente.documento + '</small>';
                            item.addEventListener("click", function() { seleccionarPaciente(paciente); });
                            resultados.appendChild(item);
                        });
                        resultados.classList.remove("d-none");
                    })
                    .catch(ocultarResultados);
            }, 220);
        });

        document.getElementById("limpiarPaciente").addEventListener("click", function() {
            documento.value = "";
            buscador.value = "";
            panel.classList.add("d-none");
            buscador.focus();
        });

        // -------------------------------------------------------------
        // BUSCADOR INTELIGENTE Y FILTRO DE TRATAMIENTOS POR CATEGORÍA
        // -------------------------------------------------------------
        const buscadorTratamiento = document.getElementById("buscadorTratamiento");
        const selectCategoria = document.getElementById("selectCategoriaTratamiento");
        const inputIdTratamiento = document.getElementById("txtIdTratamiento");
        const resultadosTratamiento = document.getElementById("resultadosTratamiento");

        const listaTratamientos = [
            <c:forEach var="t" items="${tratamientos}" varStatus="status">
                { id: "${t.id_Tipotratam}", nombre: "${t.descripcion_tipotratam}", costo: "${t.costo}", categoria: "${t.categoria_Tratamiento_id_Categoria}" }${status.last ? '' : ','}
            </c:forEach>
        ];

        function filtrarTratamientos() {
            const texto = buscadorTratamiento.value.toLowerCase().trim();
            const catId = selectCategoria.value;

            const filtrados = listaTratamientos.filter(t => {
                const coincideTexto = t.nombre.toLowerCase().includes(texto);
                const coincideCat = catId === "" || t.categoria === catId;
                return coincideTexto && coincideCat;
            });

            resultadosTratamiento.innerHTML = "";
            if (filtrados.length === 0) {
                resultadosTratamiento.innerHTML = '<div class="list-group-item py-2 text-muted">No se encontraron tratamientos</div>';
                resultadosTratamiento.classList.remove("d-none");
                return;
            }

            filtrados.forEach(t => {
                const item = document.createElement("button");
                item.type = "button";
                item.className = "list-group-item list-group-item-action d-flex justify-content-between align-items-center";
                item.innerHTML = '<span class="fw-semibold">' + t.nombre + '</span><small class="text-muted">' + formatoMoneda(t.costo) + '</small>';
                item.addEventListener("click", function() {
                    buscadorTratamiento.value = t.nombre;
                    inputIdTratamiento.value = t.id;
                    if (saldoPreview) {
                        saldoPreview.textContent = formatoMoneda(t.costo);
                    }
                    resultadosTratamiento.classList.add("d-none");
                });
                resultadosTratamiento.appendChild(item);
            });
            resultadosTratamiento.classList.remove("d-none");
        }

        if (buscadorTratamiento) {
            buscadorTratamiento.addEventListener("input", function() {
                inputIdTratamiento.value = ""; 
                filtrarTratamientos();
            });
            buscadorTratamiento.addEventListener("focus", filtrarTratamientos);
            selectCategoria.addEventListener("change", filtrarTratamientos);

            document.addEventListener("click", function(e) {
                if (!buscadorTratamiento.contains(e.target) && !resultadosTratamiento.contains(e.target)) {
                    resultadosTratamiento.classList.add("d-none");
                }
            });
        }

        form.addEventListener("submit", function(event) {
            if (!documento.value && "${empty citaEditar}" === "true") {
                event.preventDefault();
                event.stopPropagation();
                feedback.classList.remove("d-none");
                buscador.focus();
            }
        });

        const urlParams = new URLSearchParams(window.location.search);
        const limpiarUrl = () => window.history.replaceState(null, null, window.location.pathname);

        if (urlParams.get('paciente_registrado') === '1') {
            Swal.fire({ title: 'Paciente guardado', text: 'El paciente ya esta disponible para agendar la cita.', icon: 'success', confirmButtonText: 'Continuar' }).then(limpiarUrl);
            return;
        }
        if (urlParams.get('mensaje') === 'cita_creada') {
            Swal.fire({ title: 'Cita registrada', text: 'La cita quedo guardada y el pago inicial fue creado como pendiente.', icon: 'success', confirmButtonText: 'Registrar otra cita' }).then(limpiarUrl);
            return;
        }
        if (urlParams.has('paciente_error') || urlParams.has('error')) {
            Swal.fire({ title: 'No se pudo guardar', text: 'Revise los datos e intentelo nuevamente.', icon: 'error', confirmButtonText: 'Corregir' }).then(limpiarUrl);
        }
    });
</script>
</body>
</html>