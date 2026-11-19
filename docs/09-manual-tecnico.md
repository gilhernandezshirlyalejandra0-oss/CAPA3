# 9. Manual técnico

## Requisitos
- Flutter SDK estable reciente, con Dart 3.13.7 o superior (lo pide `pubspec.yaml`).
- Chrome, para la versión web.
- Para Android: Android Studio con el **Android SDK** instalado y las licencias aceptadas (`flutter doctor --android-licenses`).
- Git.

Para revisar que todo esté bien instalado:
```bash
flutter doctor
```

## Instalación
```bash
git clone https://github.com/gilhernandezshirlyalejandra0-oss/CAPA3.git
cd CAPA3/aplicacion_flutter
flutter pub get
```

## Ejecución
```bash
flutter run -d chrome                                                    # abre Chrome con la app
flutter run -d web-server --web-port 8080 --web-hostname localhost      # servidor en http://localhost:8080
flutter run                                                              # Android conectado
```
Con la app corriendo en la terminal: `r` recarga los cambios, `R` reinicia la app y `q` la cierra.

En una ventana de computador (más de 520 px de ancho) la app se muestra dentro de un marco de celular.

## Pruebas
```bash
flutter test
flutter analyze
```
Hoy hay una prueba de widget (`test/widget_test.dart`) que revisa que la bienvenida cargue y muestre el botón **Entrar**.

## Compilación
```bash
flutter build web           # queda en build/web
flutter build apk --release # queda en build/app/outputs/flutter-apk/app-release.apk
```
El APK se firma con la llave de depuración: sirve para pruebas internas, no para publicar en la Play Store.

## Paquetes
| Paquete | Para qué se usa |
|---|---|
| `go_router` | Navegación: `/bienvenida`, `/intro`, `/` (contenedor con Inicio y secciones) y `/alertas/:id` |
| `provider` | Conecta la pantalla de Chats con `AlertasViewModel` |
| `flutter_tts` | Lectura en voz alta, pausa, continuar y avance palabra por palabra |
| `google_fonts` | Tipografías Fredoka (títulos) y Nunito (textos) |
| `http` | Intenta traer los chats de un JSON remoto |
| `lottie`, `audioplayers` | Declarados en `pubspec.yaml`; no se usan en las pantallas actuales |

## Estructura de `lib/`
```
lib/
├── main.dart                 # Rutas, tema, marco de celular, Inicio + barra de secciones
├── theme/paleta.dart         # Colores (Papaya, Mostaza, Rubor, Aqua) y tipografías
├── screens/
│   ├── bienvenida_screen.dart        # Logo animado y personajes saludando
│   ├── intro_screen.dart             # Elegir guía
│   ├── inicio_screen.dart            # Inicio: saludo, frases y tarjetas de secciones
│   ├── aprende_phishing_screen.dart  # Historias
│   ├── alertas_screen.dart           # Chats y detalle en 4 pasos
│   ├── cuentos_screen.dart           # Anécdotas narradas y chisme informativo
│   ├── consejos_seguridad_screen.dart# Claves (6 reglas de oro)
│   └── cuestionario_screen.dart      # Juego (4 casos, estrellas y confeti)
├── services/
│   ├── voz_humana.dart       # Motor de voz único (VozHumana) y sus ajustes
│   ├── asistente.dart        # Guías y personajes de las historias
│   └── tamano_letra.dart     # Escala de letra (A− / A+)
├── viewmodels/alertas_viewmodel.dart  # Estados de Chats: cargando, vacío, error y listo
├── data/repositorio_alertas.dart      # Chats: JSON remoto con respaldo local
├── models/alerta_seguridad.dart
└── widgets/
    ├── avatar_parlante.dart  # Personajes dibujados que parpadean y mueven la boca
    ├── escena_animada.dart   # Escenas (imagen o dibujo) y secuencias
    ├── fondos_dibujados.dart # Lugares dibujados: casa, sala, calle y oficina
    ├── fondo_inicio.dart     # Fondo de pantalla del Inicio
    ├── animalitos.dart       # Animalitos de las frases del Inicio
    ├── logo_escudo.dart      # Logo y título animados
    └── reproductor_voz.dart  # Barra de voz y selector de voces
```

## Voz (Text-to-Speech)
- Toda la app usa un único motor, `VozHumana`, para que nunca suenen dos voces al tiempo.
- La boca de los personajes se mueve con el avance palabra por palabra que entrega `flutter_tts`.
- En Android usa la voz del sistema, que debe tener **español** instalado. En la web, las voces dependen del navegador.
- Todavía no hay un aviso cuando no hay voz disponible (tarea TASK-FE-03).

## Datos de Chats
`RepositorioAlertas` intenta descargar los mensajes de un JSON remoto. Si no responde en 1,2 segundos, usa los cinco ejemplos que vienen dentro de la app. La pantalla maneja cuatro estados: cargando, vacío, error y listo.

## Cómo agregar o cambiar contenido
| Qué | Dónde |
|---|---|
| Historias | `lib/screens/aprende_phishing_screen.dart` |
| Mensajes de Chats | `lib/data/repositorio_alertas.dart` |
| Cuentos y chismes | `lib/screens/cuentos_screen.dart` |
| Reglas de oro | `lib/screens/consejos_seguridad_screen.dart` |
| Casos del juego | `lib/screens/cuestionario_screen.dart` |
| Guías y personajes | `lib/services/asistente.dart` |
| Frases de los animalitos | `lib/screens/inicio_screen.dart` |

Salvo los mensajes de Chats, hoy el contenido vive dentro de cada pantalla. Pasarlo a `lib/data/` es una tarea pendiente (TASK-FE-05).

## Imágenes
- **Fondos del Inicio:** cualquier `.png`, `.jpg` o `.webp` en `assets/fondos/` aparece en el fondo, en orden alfabético. Ver `assets/fondos/LEEME.md`.
- **Escenas ilustradas:** las imágenes en `assets/escenas/` reemplazan a los dibujos hechos con código, si tienen el nombre exacto. Ver `assets/escenas/LEEME.md`.
- Después de agregar imágenes hay que reiniciar la app; recargar no basta.
- Las imágenes actuales de `assets/fondos/` son de otros autores: cambiarlas por imágenes propias o con permiso antes de publicar la app.

## Flujo de trabajo en Git
1. Traer lo último: `git switch main` y `git pull`.
2. Crear una rama: `git switch -c feature/nombre-corto`.
3. Hacer commits pequeños con mensajes claros (`feat:`, `fix:`, `docs:`).
4. Subir la rama (`git push -u origin feature/nombre-corto`) y abrir un Pull Request.
5. Otro integrante lo revisa; se une a `main` cuando QA lo aprueba.

Flutter modifica solo unos archivos de `linux/`, `macos/` y `windows/` cada vez que corre la app. No hacen parte del trabajo: antes de un commit se descartan con:
```bash
git restore linux macos windows
```

## Problemas comunes
| Problema | Solución |
|---|---|
| No suena la voz en la web | Probar en Chrome actualizado y elegir un narrador en los ajustes de voz |
| Los cambios no se ven en el navegador | Reiniciar con `R`; si sigue igual, recargar la página con Ctrl + Shift + R |
| Las dependencias no se resuelven | `flutter clean` y luego `flutter pub get` |
| El puerto 8080 está ocupado | Usar otro: `--web-port 8081` |
| `flutter build apk` dice "Unable to locate Android SDK" | Abrir Android Studio, terminar el asistente inicial y aceptar las licencias |
| Pantalla roja al abrir `/#/alertas/1` directamente | Esa ruta necesita el mensaje que le pasa la lista de Chats: entrar siempre desde la sección Chats |
