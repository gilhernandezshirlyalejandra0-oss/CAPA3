#  Fortaleza Cibernética

**Educación para una vida digital segura.**

Aplicación educativa, accesible y fácil de usar, que enseña a los **adultos mayores** a reconocer el phishing y otros engaños digitales que llegan por **SMS, WhatsApp y correo electrónico**. Incluye **narración por voz** para que el usuario pueda escuchar cada contenido sin depender únicamente de la lectura.

> Proyecto académico — Instituto Universitario de la Paz (IUPAZ), Escuela de Ciencias de Ingeniería Informática. Desarrollado con metodología Scrum.

##  Visión

Contribuir a que los adultos mayores naveguen con mayor confianza y autonomía, aprendiendo a identificar mensajes engañosos mediante lecciones cortas, ejemplos cotidianos, práctica y consejos claros, todo con voz narrada y diseño de alto contraste.

##  Funcionalidades

| Módulo | Descripción |
|---|---|
| 🏠 Inicio y bienvenida hablada | Saludo, voz de bienvenida y 4 accesos grandes. Si la voz no está disponible, la app avisa y sigue funcionando con botones. |
| 📘 Aprende sobre el phishing | Lecciones desplegables (qué es, cómo llegan, señales de alerta) con lectura en voz alta. |
| 💬 Reconoce los engaños | Ejemplos reales de SMS, WhatsApp y correo, con las señales que delatan el engaño. |
| ❓ Pon a prueba lo aprendido | Cuestionario de 5 preguntas con retroalimentación inmediata y barra de progreso. |
| 🔐 Consejos de seguridad | Tarjetas con recomendaciones del día a día (contraseñas, mensajes inesperados, etc.). |
| 🔊 Control de voz | Activar/desactivar narración y ajustar velocidad. |
| 📈 Mi progreso | Lecciones vistas y último resultado del cuestionario, guardados en el dispositivo. |
| 👓 Accesibilidad visual | Tamaño de texto ajustable y modo de alto contraste. |

##  Fuera del alcance

- Detectar automáticamente enlaces o mensajes fraudulentos ni garantizar protección total.
- Eliminar mensajes de WhatsApp, SMS o correo.
- Recuperar dinero perdido por estafas ni reemplazar a bancos, autoridades o servicios de denuncia.
- Sustituir antivirus u otras herramientas de ciberseguridad.

La app **educa y orienta**; no reemplaza el criterio del usuario.

##  Objetivos de Desarrollo Sostenible

- **ODS 16** Paz, justicia e instituciones sólidas: protección frente al fraude.
- **ODS 3** Salud y bienestar: menos estrés y riesgos emocionales por estafas.
- **ODS 10** Reducción de las desigualdades: acceso inclusivo y seguro a lo digital.
- **ODS 4** Educación de calidad: aprendizaje continuo para todas las edades.

##  Equipo

| Integrante | Rol Scrum | Responsabilidad técnica |
|---|---|---|
| Carlos Martínez | Product Owner | Contenido y persistencia de datos (Backend/Persistencia) |
| Nicoll Navarro | Scrum Master | Diseño UX/UI y Control de Calidad (QA), gestión del repositorio y tablero |
| Alejandra Gil | Equipo de desarrollo | Desarrollo Frontend en Flutter |

##  Tecnologías

Flutter (Dart) · Patrón MVVM · `flutter_tts` (voz) · `shared_preferences` (progreso local) · GitHub Projects (Scrum).

##  Estructura del repositorio

```
CAPA3/
├── aplicacion_flutter/   # Código fuente de la app (Flutter)
├── docs/                 # Documentación del proyecto y manuales
├── scripts/issues/       # Historias de usuario (HU-01 … HU-08)
└── README.md
```
Detalle completo en [`docs/06-estructura-del-proyecto.md`](docs/06-estructura-del-proyecto.md).

##  Ejecutar la app

```bash
cd aplicacion_flutter
flutter pub get
flutter run -d chrome      # navegador
flutter run                # dispositivo Android conectado
```

##  Documentación

1. [Visión y alcance](docs/01-vision-y-alcance.md)
2. [Roles y metodología](docs/02-roles-y-metodologia.md)
3. [Épicas y backlog](docs/03-epicas-y-backlog.md)
4. [Sprints y tareas](docs/04-sprints.md)
5. [Arquitectura](docs/05-arquitectura.md)
6. [Estructura del proyecto](docs/06-estructura-del-proyecto.md)
7. [Plan de pruebas](docs/07-plan-de-pruebas.md)
8. [Manual de usuario](docs/08-manual-de-usuario.md)
9. [Manual técnico](docs/09-manual-tecnico.md)
10. [Contenido educativo](docs/10-contenido-educativo.md)

##  Estado

Backlog reorganizado en GitHub Projects por tipo, prioridad, épica, puntos y sprint. Sprint 1 y Sprint 2 corresponden a lo ya implementado en la versión web actual (inicio, lecciones, ejemplos, cuestionario y consejos).
