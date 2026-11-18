# 7. Plan de pruebas

**Responsable:** Nicoll Navarro (QA). **Entornos:** Chrome (localhost) y dispositivo Android.

## Tipos de prueba
| Tipo | Qué valida |
|---|---|
| Funcional | Cada pantalla y botón hace lo esperado |
| Accesibilidad | Tamaño de texto, contraste, botones grandes, voz |
| Usabilidad | Un adulto mayor completa tareas sin ayuda |
| Contenido | El texto es claro, correcto y sin tecnicismos |

## Casos de prueba
| ID | HU | Caso | Resultado esperado |
|---|---|---|---|
| CP-01 | HU-01 | Abrir la app con volumen encendido | Se muestra el saludo y se escucha la bienvenida |
| CP-02 | HU-01 | Tocar cada tarjeta del inicio | Abre la pantalla correspondiente |
| CP-03 | HU-06 | Abrir la app sin voz disponible | Aparece el aviso ámbar y la app sigue usable |
| CP-04 | HU-06 | Desactivar la voz en ajustes | No se reproduce ninguna narración |
| CP-05 | HU-02 | Desplegar una lección y tocar "Escuchar" | Se lee el texto completo en voz alta |
| CP-06 | HU-02 | Desplegar otra lección | La anterior se contrae |
| CP-07 | HU-03 | Abrir "Un premio inesperado" | Muestra el mensaje y sus señales de alerta |
| CP-08 | HU-04 | Responder correctamente | Retroalimentación positiva y avance |
| CP-09 | HU-04 | Responder incorrectamente | Explica la respuesta correcta |
| CP-10 | HU-04 | Terminar las 5 preguntas | Muestra puntaje final y opción de repetir |
| CP-11 | HU-05 | Navegar por consejos | Todas las tarjetas son legibles |
| CP-12 | HU-07 | Cerrar y reabrir la app | El progreso se conserva |
| CP-13 | HU-07 | Borrar progreso | Pide confirmación y reinicia datos |
| CP-14 | HU-08 | Aumentar tamaño de texto | Ninguna pantalla se desborda |
| CP-15 | HU-08 | Activar alto contraste | Cumple contraste mínimo en todas las pantallas |

## Prueba de usabilidad (Sprint 5)
- 3–5 participantes de 60+ años.
- Tareas: (1) escuchar la bienvenida, (2) leer una lección, (3) ver un ejemplo de engaño, (4) completar el cuestionario.
- Métricas: tareas completadas sin ayuda, tiempo, errores y comentarios.
- Escala de satisfacción 1–5 al final.

## Registro de defectos
Usar issues con etiqueta `bug`: título, pasos, resultado esperado/obtenido, captura y severidad (alta/media/baja).
