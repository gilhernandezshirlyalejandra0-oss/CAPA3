# Requisitos y Calidad - Fortaleza Cibernética

## 1. Persona (Usuario representativo)
*Nombre:* Don José, 68 años. Vive solo en un barrio de Barrancabermeja.
*Situación:* Usa WhatsApp a diario para hablar con sus hijos. Hace un mes recibió un mensaje de "su banco" pidiéndole un código y casi cae en la trampa.
*Dolor:* No entiende los términos técnicos, le da miedo tocar enlaces y a veces se siente una carga al pedirle ayuda a sus hijos para revisar el celular.

## 2. Mapa de Experiencia (¿Qué hace hoy sin la app?)
1. *Recibe el mensaje:* Le llega un SMS o WhatsApp diciendo que su paquete está retenido o que le ganó un premio.
2. *Se asusta:* Siente ansiedad y confusión.
3. *Busca ayuda:* Llama a su hijo, pero a veces él está trabajando y no contesta.
4. *Decide:* Por miedo a perder el paquete, toca el enlace.
5. *Frustración:* Lo estafan o le roban datos.

*Cambio en la app que surgió de esto:* Decidimos que la pantalla de inicio (HU-01) debe tener un botón gigante que diga "Pedir ayuda a familiar" (HU-05), para que Don José no tenga que buscar la app de WhatsApp ni escribir, sino que con un toque se envíe la alerta.

## 3. Criterios de Accesibilidad y UX/UI (Liderado por Carlos)
Para garantizar que Don José pueda usar la aplicación sin frustraciones, se definieron las siguientes reglas de diseño:
- *Tamaño de toque:* Todos los botones principales deben medir mínimo *48x48 dp* (el estándar de accesibilidad de Google), evitando toques accidentales.
- *Tipografía:* El texto debe tener un tamaño mínimo de *24 sp* y usar fuentes sin serifas (como Roboto) para facilitar la lectura.
- *Contraste:* Relación de contraste mínima de 4.5:1 (fondo claro con letras oscuras o viceversa) para adultos mayores con vista cansada.
- *Arquitectura de Estados:* Ninguna pantalla debe quedar en blanco. Se diseñaron los 4 estados visuales para la pantalla principal (Carga, Vacío, Error y Datos) para que el usuario siempre sepa qué está pasando.

## 4. Requisitos de Calidad (Con números)
- *Accesibilidad:* Los botones principales de la pantalla de inicio deben medir mínimo 48x48 dp y el texto debe tener un tamaño mínimo de 24 sp.
- *Rendimiento:* La aplicación debe abrir y mostrar el menú principal en *menos de 2 segundos* en un celular Android de gama baja (2GB de RAM).
- *Usabilidad (Regla de Nielsen aplicada):* "Ayuda y documentación". Descubrimos que si el usuario no sabe qué hacer, debe haber un botón de "Escuchar instrucciones" (voz), no solo texto.
