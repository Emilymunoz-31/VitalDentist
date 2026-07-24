<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vital Dentist | Inicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Landing.css">
</head>
<body class="d-flex flex-column min-vh-100 overflow-hidden">

    <div class="logo-intro" aria-hidden="true">
        <img src="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png" alt="">
    </div>

    <header class="header-color px-3 py-3 position-relative z-index-10">
        <div class="container-fluid d-flex align-items-center">
            <img src="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png" alt="Logo" class="brand-logo me-3">
            <span class="brand-name text-white m-0 fs-3 fw-bold">Vital Dentist</span>
        </div>
    </header>

    <main class="landing-main flex-grow-1 d-flex align-items-center position-relative z-index-10">
        <div class="container">
            <div class="row align-items-center justify-content-center g-4 g-lg-5">
                <div class="col-12 col-lg-5 order-2 order-lg-1 text-center text-lg-start">
                    <p class="landing-kicker mb-2">Agenda odontológica</p>
                    <h1 class="landing-title mb-3">Vital Dentist</h1>
                    <p class="landing-copy mb-4">
                        Gestiona citas odontológicas de forma rápida, segura y sencilla. Nuestra plataforma permite a especialistas administrar agendas, consultar horarios disponibles y mantener un mejor control de cada atención.
                    </p>

                    <div class="button-wrapper">
                        <a href="${pageContext.request.contextPath}/Vista/Login.jsp" class="btn-gradient">
                            Iniciar Sesión
                        </a>
                    </div>
                </div>

                <div class="col-12 col-lg-7 order-1 order-lg-2">
                    <div class="implant-wrapper text-center">
                        <img src="${pageContext.request.contextPath}/Vista/Imagenes/implante_3d1.png" alt="Implante" class="implant-giant img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer-color p-3 text-center position-relative z-index-10">
        <span class="text-light small fw-light">&copy; 2026 Vital Dentist. Panel de Agenda Odontológica.</span>
    </footer>

</body>
</html>
