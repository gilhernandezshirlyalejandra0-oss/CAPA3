# 9. Manual técnico

## Requisitos
- Flutter SDK estable (3.x) y Dart.
- Chrome (para versión web) o Android Studio / dispositivo Android.
- Git.

## Instalación
```bash
git clone https://github.com/nicoll1820/CAPA3.git
cd CAPA3/aplicacion_flutter
flutter pub get
```

## Ejecución
```bash
flutter run -d chrome     # web
flutter run               # Android conectado
```

## Pruebas
```bash
flutter test
flutter analyze
```

## Compilación
```bash
flutter build web         # carpeta build/web
flutter build apk --release
```

## Voz (Text-to-Speech)
- En Android usa el motor de voz del sistema; debe tener **español** instalado.
- En navegador la voz depende del soporte del navegador; si falla se muestra el aviso "La bienvenida hablada no está disponible en este dispositivo".

## Cómo agregar contenido
Editar los archivos de `lib/data/` (lecciones, ejemplos, preguntas, consejos). No hace falta tocar las pantallas.

## Flujo de trabajo en Git
1. Crear rama: `git checkout -b feat/hu-04-cuestionario`.
2. Commits pequeños con la convención del proyecto.
3. Pull Request con revisión de otro integrante.
4. Fusionar a `main` cuando QA apruebe.

## Problemas comunes
| Problema | Solución |
|---|---|
| `flutter_tts` no suena en web | Probar en Chrome actualizado o en Android |
| Dependencias no resuelven | `flutter clean && flutter pub get` |
| Puerto ocupado en localhost | `flutter run -d chrome --web-port 8080` |
