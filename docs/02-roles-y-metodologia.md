# 2. Roles y metodología

## Roles Scrum
| Rol | Persona | Función |
|---|---|---|
| Product Owner | Carlos Martínez | Define la visión, el contenido educativo y prioriza las historias de usuario |
| Scrum Master | Nicoll Navarro | Facilita las ceremonias, gestiona el repositorio, los archivos y el tablero |
| Equipo de desarrollo | Nicoll, Alejandra, Carlos | Construyen e incrementan el producto |

## Roles técnicos
| Persona | Área | Código de tareas |
|---|---|---|
| Nicoll Navarro | Diseño UX/UI y QA | `TASK-UX-xx`, `TASK-QA-xx` |
| Alejandra Gil | Desarrollo Frontend (Flutter) | `TASK-FE-xx` |
| Carlos Martínez | Persistencia y contenido | `TASK-DB-xx` |

## Ceremonias
- **Sprint Planning** al inicio de cada sprint.
- **Daily** breve (15 min o asíncrona por chat).
- **Sprint Review**: demostración de la app funcionando.
- **Retrospectiva**: qué mejorar en el siguiente sprint.

## GitHub Projects
Campos: **Tipo** (HU / TASK / BUG), **Prioridad** (Alta / Media / Baja), **Épica**, **Puntos** (1-2-3-5-8) y **Sprint**.
Columnas: *Backlog → Por hacer → En progreso → En revisión (QA) → Hecho*.

## Convención de commits
`docs:` documentación · `feat:` funcionalidad · `fix:` corrección · `test:` pruebas · `style:` diseño.
Ejemplo: `feat: pantalla de cuestionario con barra de progreso`.

## Definición de Hecho (DoD)
- Cumple todos los criterios de aceptación de la HU.
- Probada por QA (funcional y accesibilidad).
- Texto legible (mínimo 18 pt) y buen contraste.
- Sin errores en consola.
- Documentada y fusionada en `main`.

## Definición de Listo (DoR)
HU con formato "Como… quiero… para…", criterios de aceptación, puntos y prioridad.
