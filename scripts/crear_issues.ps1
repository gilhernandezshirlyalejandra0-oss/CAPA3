\xef\xbb\xbf# =====================================================================
#  crear_issues.ps1  -  Crea etiquetas, milestones (sprints) e issues
#  (HU + TASK) del proyecto Fortaleza Cibernética con gh CLI.
#  Uso (desde la carpeta scripts):  .\crear_issues.ps1
# =====================================================================
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$repo = "gilhernandezshirlyalejandra0-oss/CAPA3"
$user = @{
  UX  = "nicoll1820"
  FE  = "gilhernandezshirlyalejandra0-oss"
  QA  = "carlosandresmartinezalvear"
}
$labelDeRol = @{ UX = "UX/UI"; FE = "Frontend"; QA = "QA"; DOC = "Documentación" }

gh auth status | Out-Null

# ---------- 0. (Opcional) cerrar issues del plan anterior ----------
$resp = Read-Host "¿Cerrar los issues ABIERTOS del plan anterior (IA, WhatsApp, etc.)? (s/n)"
if ($resp -eq "s") {
  $viejos = gh issue list --repo $repo --state open --limit 200 --json number | ConvertFrom-Json
  foreach ($i in $viejos) {
    gh issue close $i.number --repo $repo --reason "not planned" `
      --comment "Cerrado: el proyecto cambió de enfoque a una app educativa sobre phishing. Queda como trabajo futuro." | Out-Null
    Write-Host "Cerrado #$($i.number)"
  }
}

# ---------- 1. Etiquetas ----------
$labels = @(
  @("Historia de usuario","0E8A16","Historia de usuario (HU)"),
  @("Task","1D76DB","Tarea derivada de una HU"),
  @("UX/UI","D93F0B","Diseño y contenido"),
  @("Frontend","C5DEF5","Desarrollo Flutter"),
  @("QA","FBCA04","Pruebas y calidad"),
  @("Documentación","0075CA","Documentos y cierre"),
  @("Prioridad: Alta","B60205","Prioridad alta"),
  @("Prioridad: Media","FF9F1C","Prioridad media")
)
foreach ($l in $labels) {
  gh label create $l[0] --repo $repo --color $l[1] --description $l[2] --force | Out-Null
}
Write-Host "Etiquetas listas."

# ---------- 2. Milestones (sprints) ----------
$sprints = @{
  1 = @("Sprint 1: Fundamentos, bienvenida y voz","HU-01, HU-06")
  2 = @("Sprint 2: Lecciones y ejemplos de engaños","HU-02, HU-03")
  3 = @("Sprint 3: Cuestionario y consejos","HU-04, HU-05")
  4 = @("Sprint 4: Progreso del usuario","HU-07")
  5 = @("Sprint 5: Accesibilidad y cierre","HU-08")
}
foreach ($k in ($sprints.Keys | Sort-Object)) {
  gh api "repos/$repo/milestones" -f title="$($sprints[$k][0])" -f description="Historias: $($sprints[$k][1])" --silent
}
Write-Host "Milestones listos."

# ---------- función para crear issue ----------
function New-Issue($title, $body, $lbls, $milestone, $assignees) {
  $tmp = [IO.Path]::GetTempFileName()
  [IO.File]::WriteAllText($tmp, $body, (New-Object Text.UTF8Encoding $false))
  $ghArgs = @("issue","create","--repo",$repo,"--title",$title,"--body-file",$tmp,
              "--label",($lbls -join ","),"--milestone",$milestone)
  foreach ($a in $assignees) { $ghArgs += @("--assignee",$a) }
  $out = & gh @ghArgs
  Remove-Item $tmp
  Start-Sleep -Milliseconds 800
  return ($out | Select-Object -Last 1)
}

# ---------- 3. Historias de usuario ----------
# id, título, prioridad, sprint, puntos
$hus = @(
  @("HU-01","Bienvenida hablada y menú de inicio con botones grandes","Alta",1,5),
  @("HU-06","Control de voz: activar/desactivar, velocidad y aviso","Alta",1,5),
  @("HU-02","Lecciones sobre phishing con lectura en voz alta","Alta",2,8),
  @("HU-03","Ejemplos de engaños por SMS, WhatsApp y correo","Alta",2,8),
  @("HU-04","Cuestionario de 5 preguntas con retroalimentación","Alta",3,8),
  @("HU-05","Consejos de seguridad del día a día","Media",3,3),
  @("HU-07","Mi progreso: lecciones vistas y resultado del cuestionario","Media",4,5),
  @("HU-08","Accesibilidad visual: texto ajustable y alto contraste","Media",5,5)
)
$huNum = @{}
foreach ($h in $hus) {
  $archivo = Join-Path $PSScriptRoot "issues\$($h[0]).md"
  if (Test-Path $archivo) { $body = Get-Content $archivo -Raw -Encoding UTF8 } else { $body = "Ver criterios en docs/03-epicas-y-backlog.md" }
  $body += "`n`n---`n**Puntos:** $($h[4])"
  $url = New-Issue "$($h[0]): $($h[1])" $body @("Historia de usuario","Prioridad: $($h[2])") $sprints[$h[3]][0] @()
  $huNum[$h[0]] = [int](($url -split "/")[-1])
  Write-Host "Creado $($h[0]) -> $url"
}

# ---------- 4. Tareas ----------
# código, título, descripción, HU, sprint
$tareas = @(
  # Sprint 1
  @("UX-01","Wireframes y paleta de alto contraste","Diseñar wireframes del inicio y definir la paleta azul / verde / ámbar de alto contraste.","HU-01",1),
  @("FE-01","Configurar proyecto Flutter, MVVM, tema y pantalla de inicio","Estructura MVVM, tema accesible y pantalla de inicio con 4 tarjetas grandes.","HU-01",1),
  @("FE-02","Integrar flutter_tts y bienvenida hablada","Servicio de voz en español y saludo hablado al abrir la app.","HU-01",1),
  @("FE-03","Aviso visual cuando la voz no está disponible","Recuadro ámbar con el mensaje del plan B; la app sigue usable.","HU-06",1),
  @("FE-04","Ajustes de voz: activar/desactivar y velocidad","Pantalla de ajustes con interruptor de voz y velocidad (Lenta/Normal/Rápida); guardar preferencia.","HU-06",1),
  @("FE-05","Modelos de datos de contenido","Modelos Lesson, ScamExample, QuizQuestion y SecurityTip en lib/models y datos en lib/data.","HU-01",1),
  @("QA-01","Pruebas de accesibilidad y navegación del inicio y la voz","Ejecutar CP-01 a CP-04 del plan de pruebas y reportar defectos.","HU-01",1),
  # Sprint 2
  @("UX-02","Diseño de lecciones desplegables y tarjetas de ejemplo","Diseño del acordeón de lecciones y de las tarjetas/detalle de ejemplos.","HU-02",2),
  @("UX-03","Redacción del contenido: 4 lecciones y 3 ejemplos","Textos simples y sin tecnicismos (ver docs/10-contenido-educativo.md).","HU-02",2),
  @("FE-06","Pantalla Aprende sobre el phishing con acordeón","Lecciones desplegables; al abrir una se contraen las demás.","HU-02",2),
  @("FE-07","Pantalla Reconoce los engaños y detalle de cada ejemplo","Lista numerada con canal y detalle con señales de alerta.","HU-03",2),
  @("FE-08","Botón Escuchar en lecciones y ejemplos","Lectura en voz alta con opción de detener; oculto o explicado si no hay voz.","HU-02",2),
  @("QA-02","Pruebas de lectura en voz alta y legibilidad del contenido","Ejecutar CP-05 a CP-07 y revisar claridad de los textos.","HU-02",2),
  # Sprint 3
  @("UX-04","Diseño del cuestionario, barra de progreso y resultado","Diseño de pregunta con 3 opciones, barra de avance y pantalla de puntaje.","HU-04",3),
  @("UX-05","Redacción de 5 preguntas y de los consejos","Preguntas con respuesta correcta y explicación amable; consejos cortos.","HU-04",3),
  @("FE-09","Pantalla de cuestionario con retroalimentación inmediata","Pregunta X de 5, barra de progreso, mensaje correcto/incorrecto y resultado final con opción de repetir.","HU-04",3),
  @("FE-10","Pantalla Consejos de seguridad con tarjetas","Tarjetas con título, explicación y consejo destacado; letra grande.","HU-05",3),
  @("QA-03","Pruebas de respuestas correctas/incorrectas y reinicio","Ejecutar CP-08 a CP-11.","HU-04",3),
  # Sprint 4
  @("UX-06","Diseño de Mi progreso y estados vacíos","Pantalla de progreso y mensaje amable cuando no hay datos.","HU-07",4),
  @("FE-11","Persistencia local con shared_preferences","StorageService: lecciones vistas y último puntaje.","HU-07",4),
  @("FE-12","ViewModel y pantalla de progreso; borrar progreso","Mostrar progreso, marcar lecciones completadas y botón Borrar mi progreso con confirmación.","HU-07",4),
  @("QA-04","Pruebas de guardado, recarga y borrado de progreso","Ejecutar CP-12 y CP-13.","HU-07",4),
  # Sprint 5
  @("UX-07","Diseño del selector de tamaño de texto y alto contraste","Diseño de los controles de accesibilidad visual en Ajustes.","HU-08",5),
  @("FE-13","Texto ajustable, tema de alto contraste y guardado de preferencias","Tamaños Normal/Grande/Extra grande sin desbordes; tema alto contraste; persistir al reabrir.","HU-08",5),
  @("QA-05","Pruebas de usabilidad con 3 a 5 adultos mayores y reporte","Ejecutar CP-14 y CP-15 y la prueba de usabilidad; entregar reporte de hallazgos.","HU-08",5),
  @("DOC-01","Cierre: manuales, video de demostración y presentación final","Revisar manuales, grabar video de demo y preparar la presentación.","HU-08",5)
)
foreach ($t in $tareas) {
  $rol = ($t[0] -split "-")[0]
  if ($rol -eq "DOC") { $asig = @($user.UX,$user.FE,$user.QA) } else { $asig = @($user[$rol]) }
  $body = "**Historia relacionada:** #$($huNum[$t[3]]) ($($t[3]))`n`n**Descripción:** $($t[2])`n`n**Definición de Hecho:** cumple los criterios de la HU, probada por QA, texto legible (mínimo 18 pt) y fusionada en main."
  $url = New-Issue "TASK-$($t[0]): $($t[1])" $body @("Task",$labelDeRol[$rol]) $sprints[$t[4]][0] $asig
  Write-Host "Creado TASK-$($t[0]) -> $url"
}
Write-Host "`nListo. Revisa https://github.com/$repo/issues"
