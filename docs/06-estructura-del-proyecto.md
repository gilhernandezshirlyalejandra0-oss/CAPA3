# 6. Estructura del proyecto

> Esta estructura reemplaza la anterior. Las carpetas `lib/` y `test/` de la raíz estaban vacías (pertenecían al plan inicial) y se eliminan; el código real vive en `aplicacion_flutter/`.

```
CAPA3/
├── README.md
├── aplicacion_flutter/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/            # tema, colores, constantes, accesibilidad
│   │   ├── data/            # contenido: lecciones, ejemplos, preguntas, consejos
│   │   ├── models/          # Lesson, ScamExample, QuizQuestion, SecurityTip
│   │   ├── services/        # speech_service.dart, storage_service.dart
│   │   ├── viewmodels/      # home, quiz, progress, settings
│   │   └── views/           # home, lessons, scams, quiz, tips, progress, settings
│   ├── test/                # pruebas unitarias y de widgets
│   ├── pubspec.yaml
│   └── web/ android/ ...
├── docs/
│   ├── 01-vision-y-alcance.md … 10-contenido-educativo.md
└── scripts/
    ├── crear_issues.sh      # crea las HU en GitHub con gh CLI
    └── issues/              # HU-01.md … HU-08.md
```

## Pasos para limpiar el repositorio
1. Mover/confirmar que todo el código vive dentro de `aplicacion_flutter/`.
2. Eliminar las carpetas vacías `lib/` y `test/` de la raíz.
3. Reemplazar `README.md`, `docs/` y `scripts/issues/` por los archivos nuevos.
4. Borrar de GitHub Projects las tarjetas del plan anterior (IA, WhatsApp, historial, red de apoyo) o moverlas a una columna **"Trabajo futuro"**.
5. Hacer commit: `docs: reestructura del proyecto hacia app educativa de phishing`.

