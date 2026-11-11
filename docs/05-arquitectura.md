# 5. Arquitectura

## Enfoque
Aplicación Flutter con patrón **MVVM**, organizada por funcionalidades. Todo el contenido educativo se mantiene separado de la interfaz para poder editarlo sin tocar las pantallas.

```
Vista (Screens/Widgets)  ⇄  ViewModel  ⇄  Servicios / Repositorios  ⇄  Datos locales
```

| Capa | Responsabilidad | Ejemplos |
|---|---|---|
| Vista | Mostrar contenido, capturar toques | `HomeScreen`, `LessonsScreen`, `QuizScreen` |
| ViewModel | Estado y lógica de pantalla | `QuizViewModel`, `ProgressViewModel` |
| Servicios | Voz y almacenamiento | `SpeechService` (flutter_tts), `StorageService` (shared_preferences) |
| Modelos / Datos | Contenido educativo | `Lesson`, `ScamExample`, `QuizQuestion`, `SecurityTip` |

## Decisiones de diseño
- **Voz con plan B:** si `flutter_tts` falla o no hay idioma español, `SpeechService` informa al ViewModel y la UI muestra un aviso, sin bloquear la app.
- **Contenido local:** sin servidor ni internet; la app funciona sin conexión.
- **Persistencia ligera:** `shared_preferences` es suficiente para progreso y preferencias.
- **Accesibilidad primero:** botones grandes, texto mínimo 18 pt, contraste alto, uno-por-fila.

## Dependencias
| Paquete | Uso |
|---|---|
| `flutter_tts` | Narración por voz |
| `shared_preferences` | Progreso y preferencias |
| `provider` (o similar) | Gestión de estado MVVM |

## Flujo de navegación
```
Inicio ─┬─ Aprende sobre el phishing
        ├─ Reconoce los engaños ── Detalle del ejemplo
        ├─ Pon a prueba lo aprendido ── Resultado
        ├─ Consejos de seguridad
        └─ Mi progreso / Ajustes (accesibilidad y voz)
```
