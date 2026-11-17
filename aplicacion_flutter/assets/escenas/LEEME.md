# Ilustraciones de Escudo Mayor

La app **ya funciona sin estas imágenes**: si una no existe, la escena se
dibuja sola con código (fondos de casa, calle u oficina + personaje animado).

Si quieren la calidad de un libro ilustrado (acuarela, óleo, cuento), generen
las imágenes con una IA de imágenes y guárdenlas **en esta carpeta** con el
**nombre exacto** de la tabla. La app las detecta sola y les pone movimiento
suave (acercamiento y deslizamiento), y las cambia al ritmo de la narración.

> Son **imágenes**, no videos. Una por escena.

## Cómo generarlas (paso a paso)

1. Abran una IA de imágenes. Opciones con uso gratuito (los límites cambian):
   **Gemini** (gemini.google.com), **Microsoft Copilot / Bing Image Creator**,
   **Leonardo.ai** o **Ideogram**. Gemini mantiene muy bien el mismo personaje
   entre una imagen y otra si se lo piden en la misma conversación.
2. Peguen primero el **ESTILO** y la **FICHA DEL PERSONAJE**, luego la escena.
3. Pidan formato **horizontal 4:3** (por ejemplo 1024 × 768).
4. Para la siguiente escena del mismo cuento escriban:
   *"Mismo personaje y mismo estilo que la imagen anterior. Ahora: …"*
5. Descarguen la imagen como **PNG** y renómbrenla exactamente como dice la tabla.
6. Cópienla a `aplicacion_flutter/assets/escenas/` y reinicien la app.

## ESTILO (pegar siempre)

> Ilustración de libro infantil, estilo acuarela cálida con trazos finos de
> lápiz de color, paleta crema, beige, durazno, rojo papaya, mostaza y verde
> agua. Personajes tiernos con ojos grandes y oscuros, mejillas sonrosadas y
> expresiones claras. Fondos acogedores llenos de detalles cotidianos
> colombianos (matas, tazas, cortinas, tapetes). Luz suave. Sin texto escrito
> en la imagen. Formato horizontal 4:3.

## Fichas de personajes (para que siempre se vean iguales)

- **Doña Carmen**: señora colombiana de 71 años, piel clara, cabello gris
  recogido en un moño con rizos, gafas redondas de marco café, blusa rosada
  con flores pequeñas, delantal verde.
- **Andrés (nieto)**: muchacho de 20 años, piel trigueña, pelo castaño
  ondulado corto, camiseta verde agua, morral.
- **Don Hernando**: señor de 66 años, piel morena, pelo blanco corto y bigote
  blanco, camisa verde, sombrero vueltiao en algunas escenas.
- **Gloria**: señora de 69 años, piel trigueña, pelo castaño con canas en
  moño, blusa verde agua, aretes pequeños.
- **Rubén**: señor de 74 años, piel morena clara, pelo canoso peinado hacia
  atrás, gafas, camisa roja de cuadros.
- **Mercedes**: señora de 63 años, piel trigueña, pelo negro rizado corto,
  blusa amarilla mostaza.

## Lista de imágenes

### Cuento: Doña Carmen y el nieto que no era
| Archivo | Escena |
|---|---|
| `carmen_1.png` | Doña Carmen regando las matas en su cocina por la mañana; mira sorprendida su celular que acaba de sonar. |
| `carmen_2.png` | Doña Carmen sentada en la sala, preocupada, leyendo en el celular que su "nieto" necesita plata urgente. |
| `carmen_3.png` | Doña Carmen en la calle frente a un corresponsal bancario; se detiene con cara de "¡ya me acordé!", con un bombillo sobre la cabeza. |
| `carmen_4.png` | Doña Carmen feliz y aliviada hablando por videollamada con su nieto Andrés, que está en un salón de clase. |

### Cuento: El paquete que nunca existió
| Archivo | Escena |
|---|---|
| `hernando_1.png` | Don Hernando en su casa mirando un mensaje en el celular sobre un paquete retenido. |
| `hernando_2.png` | Don Hernando escribiendo los números de su tarjeta en el celular, con cara de duda. |
| `hernando_3.png` | De noche, Don Hernando asustado mirando en el celular cobros extraños. |
| `hernando_4.png` | Don Hernando tranquilo, enseñándole a su vecino a borrar mensajes sospechosos. |

### Cuento: La llamada del "banco" a la hora del almuerzo
| Archivo | Escena |
|---|---|
| `gloria_1.png` | Gloria almorzando en su cocina y contestando una llamada, sorprendida. |
| `gloria_2.png` | Gloria preocupada al teléfono mientras al otro lado (en un recuadro) un hombre de traje le pide un código. |
| `gloria_3.png` | Gloria colgando el teléfono con decisión y sonrisa segura. |
| `gloria_4.png` | Gloria feliz llamando a la línea oficial de su banco, que está detrás de su tarjeta. |

### Cuento: El amor que llegó por Facebook
| Archivo | Escena |
|---|---|
| `ruben_1.png` | Rubén sonriendo enamorado frente al computador, con corazones flotando. |
| `ruben_2.png` | Rubén preocupado mirando en la pantalla una petición de dinero para un tiquete de avión. |
| `ruben_3.png` | La hija de Rubén le muestra en su celular que las fotos de "Valeria" son de una modelo; Rubén sorprendido. |
| `ruben_4.png` | Rubén y su hija abrazados en la sala, tranquilos. |

### Cuento: El subsidio que costaba plata
| Archivo | Escena |
|---|---|
| `mercedes_1.png` | Mercedes leyendo en el grupo de WhatsApp del barrio un mensaje de "nuevo subsidio". |
| `mercedes_2.png` | Mercedes frente a una página que le pide dinero para inscribirse, con cara de sospecha. |
| `mercedes_3.png` | Mercedes conversando en la calle con su vecina que trabaja en la alcaldía. |
| `mercedes_4.png` | Mercedes contenta borrando el mensaje falso. |

### Sección Historias (una imagen por historia)
| Archivo | Escena |
|---|---|
| `historia_1.png` | Una señora feliz pero dudosa con un regalo gigante que sale del celular (falso premio). |
| `historia_2.png` | Un señor asustado recibiendo una llamada urgente "del banco". |
| `historia_3.png` | Una abuela leyendo un WhatsApp de un número desconocido con la foto de su nieto. |
| `historia_4.png` | Una señora tranquila tomando café con el celular boca abajo en la mesa (regla de los 5 minutos). |

### Sección Chats (opcional)
`chats_portada.png` y, por cada mensaje N del 1 al 5: `chat_N_trampa.png`
(el estafador disfrazado), `chat_N_pistas.png` (alguien revisando el mensaje
con lupa) y `chat_N_solucion.png` (la persona tranquila tras borrar el mensaje).

### Sección Juego (opcional)
`juego_1.png` a `juego_4.png` (una por caso) y `juego_final.png` (celebración).

### Sección Claves (opcional)
`regla_1.png` a `regla_6.png`, una por cada regla de oro.
