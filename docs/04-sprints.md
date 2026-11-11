# 4. Sprints y tareas

Duración sugerida: 1 semana por sprint. Códigos: **UX** diseño · **FE** frontend · **DB** persistencia/contenido · **QA** calidad.

## 🏃 Sprint 1 — Fundamentos, bienvenida y voz
**Objetivo:** tener la arquitectura base, la pantalla de inicio accesible y la narración por voz con su plan B.
**Historias:** HU-01, HU-06

| Tarea | Descripción | Responsable |
|---|---|---|
| TASK-UX-01 | Wireframes y paleta de alto contraste (azul / verde / ámbar) | Nicoll |
| TASK-FE-01 | Configurar proyecto Flutter, MVVM, tema y pantalla de inicio | Alejandra |
| TASK-FE-02 | Integrar `flutter_tts` y bienvenida hablada | Alejandra |
| TASK-FE-03 | Aviso visual cuando la voz no está disponible | Alejandra |
| TASK-DB-01 | Estructura de contenido (modelos de lección, ejemplo, pregunta, consejo) | Carlos |
| TASK-QA-01 | Pruebas de accesibilidad y navegación del inicio | Nicoll |

## 🏃 Sprint 2 — Lecciones y ejemplos de engaños
**Objetivo:** que el usuario aprenda qué es el phishing y vea ejemplos reales.
**Historias:** HU-02, HU-03

| Tarea | Descripción | Responsable |
|---|---|---|
| TASK-UX-02 | Diseño de lecciones desplegables y tarjetas de ejemplo | Nicoll |
| TASK-DB-02 | Redacción y carga del contenido de lecciones (4) y ejemplos (3) | Carlos |
| TASK-FE-04 | Pantalla "Aprende sobre el phishing" con acordeón | Alejandra |
| TASK-FE-05 | Pantalla "Reconoce los engaños" y detalle de cada ejemplo | Alejandra |
| TASK-FE-06 | Botón "Escuchar" en lecciones y ejemplos | Alejandra |
| TASK-QA-02 | Pruebas de lectura en voz alta y legibilidad del contenido | Nicoll |

## 🏃 Sprint 3 — Cuestionario y consejos
**Objetivo:** que el usuario practique lo aprendido y reciba recomendaciones.
**Historias:** HU-04, HU-05

| Tarea | Descripción | Responsable |
|---|---|---|
| TASK-UX-03 | Diseño del cuestionario, barra de progreso y pantalla de resultado | Nicoll |
| TASK-DB-03 | Banco de 5 preguntas con respuesta correcta y explicación | Carlos |
| TASK-FE-07 | Pantalla de cuestionario con retroalimentación inmediata | Alejandra |
| TASK-FE-08 | Pantalla "Consejos de seguridad" con tarjetas | Alejandra |
| TASK-QA-03 | Pruebas de respuestas correctas/incorrectas y reinicio del cuestionario | Nicoll |

## 🏃 Sprint 4 — Progreso del usuario
**Objetivo:** guardar localmente lo que el usuario ha aprendido.
**Historias:** HU-07

| Tarea | Descripción | Responsable |
|---|---|---|
| TASK-UX-04 | Diseño de la pantalla "Mi progreso" y sus estados vacíos | Nicoll |
| TASK-DB-04 | Persistencia local con `shared_preferences` (lecciones vistas, último puntaje) | Carlos |
| TASK-FE-09 | ViewModel y pantalla de progreso; marca de lección completada | Alejandra |
| TASK-QA-04 | Pruebas de guardado, recarga de la app y borrado de progreso | Nicoll |

## 🏃 Sprint 5 — Accesibilidad avanzada y cierre
**Objetivo:** pulir la experiencia para adultos mayores y validar con usuarios reales.
**Historias:** HU-08

| Tarea | Descripción | Responsable |
|---|---|---|
| TASK-UX-05 | Diseño del selector de tamaño de texto y modo alto contraste | Nicoll |
| TASK-FE-10 | Implementar tamaño de texto ajustable y tema de alto contraste | Alejandra |
| TASK-DB-05 | Guardar preferencias de accesibilidad | Carlos |
| TASK-QA-05 | Pruebas de usabilidad con 3–5 adultos mayores y reporte de hallazgos | Nicoll |
| TASK-DOC-01 | Cierre: manuales, video de demostración y presentación final | Todo el equipo |

## Resumen de carga
| Sprint | Historias | Puntos |
|---|---|---|
| 1 | HU-01, HU-06 | 10 |
| 2 | HU-02, HU-03 | 16 |
| 3 | HU-04, HU-05 | 11 |
| 4 | HU-07 | 5 |
| 5 | HU-08 | 5 |
