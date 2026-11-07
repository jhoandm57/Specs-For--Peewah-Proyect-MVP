---
id: F-04
titulo: Revisar los bloques sugeridos
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-06, RF-07, RF-08, RF-09, RF-10, RNF-03, RNF-06]
depende_de: [F-03]
---

# F-04 · Revisar los bloques sugeridos

## Objetivo

En el paso 2, el administrador recibe un formulario de inscripción, un cronograma y unas tareas sugeridas a partir de eventos similares de su organización, y decide qué hace con cada bloque.

## Flujo principal

1. Al abrir el paso 2, el sistema busca los eventos de la organización similares al nuevo.
2. El sistema muestra tres bloques: formulario de inscripción, cronograma de actividades y tareas con responsables, y para cada uno indica de qué eventos salió.
3. Por cada bloque, el administrador elige "Aceptar", "Editar" o "Rechazar".
4. El sistema guarda la decisión de cada bloque.
5. Cuando los tres bloques tienen decisión, el administrador elige "Siguiente" y el sistema abre el paso 3 (F-05).

## Flujos alternos

- **A1 · Sin historial suficiente:** si la organización no tiene eventos similares, el sistema muestra la configuración típica de la categoría y el aviso "Tu organización no tiene eventos similares; esta es la configuración típica de un <tipo>".
- **A2 · Editar:** el administrador agrega, cambia o quita campos del formulario, actividades del cronograma o tareas, y elige "Guardar cambios"; el bloque queda como editado.
- **A3 · Rechazar:** el bloque queda vacío y marcado como rechazado.
- **A4 · Cambiar de decisión:** antes de confirmar el evento (F-06), el administrador puede cambiar la decisión de un bloque; vale la última.

## Reglas

- Las sugerencias solo usan eventos de la organización del usuario con sesión.
- Un evento es similar si tiene el mismo tipo y la misma modalidad que el nuevo.
- Cada bloque sugerido se guarda con decisión pendiente antes de mostrarse; la decisión del administrador lo actualiza.
- Se conserva lo que sugirió el sistema y, aparte, el contenido que quedó tras editarlo.
- No se avanza al paso 3 sin una decisión en los tres bloques.
- Los bloques aparecen en menos de 10 segundos después de abrir el paso 2 (RNF-03).

## Estados

- **Cargando:** "Buscando eventos similares…".
- **Vacío:** si tampoco hay configuración típica para la categoría, "No hay sugerencias para este tipo de evento" y los tres bloques en blanco para llenarlos a mano.
- **Error:** "No se pudieron generar las sugerencias" y la opción de reintentar.

## Datos

- Bloque sugerido: tipo de bloque (formulario, cronograma o tareas), contenido sugerido, eventos de origen, decisión (pendiente, aceptado, editado o rechazado), contenido editado.
- Formulario: campos con su nombre y si son obligatorios.
- Cronograma: actividades con su día y hora relativos al evento.
- Tareas: nombre, responsable y días antes del evento en que vence.

## Criterios de aceptación

- **CA-1** Dado que la organización tiene 2 congresos presenciales, cuando el administrador describe un congreso presencial y llega al paso 2, entonces ve los tres bloques y que salieron de esos 2 congresos.
- **CA-2** Dado que la organización no tiene ferias, cuando el administrador describe una feria, entonces ve la configuración típica de una feria y el aviso de que no hay eventos similares.
- **CA-3** Dado el bloque de cronograma, cuando el administrador elige "Rechazar", entonces el bloque queda vacío y marcado como rechazado.
- **CA-4** Dado el bloque de formulario, cuando el administrador agrega un campo y elige "Guardar cambios", entonces el bloque queda marcado como editado y muestra el campo nuevo.
- **CA-5** Dado que solo dos bloques tienen decisión, cuando el administrador intenta avanzar, entonces ve "Decide qué haces con los tres bloques" y sigue en el paso 2.
- **CA-6** Dado que el administrador aceptó, editó y rechazó un bloque cada uno, cuando consulta el evento después (F-07), entonces ve esas tres decisiones.
- **CA-7** Dado el paso 1 completo, cuando el administrador abre el paso 2 con conexión, entonces los tres bloques aparecen en menos de 10 segundos.
- **CA-8** Dado que no hay conexión, cuando se abre el paso 2, entonces el administrador ve "No se pudieron generar las sugerencias" y puede reintentar.

## Fuera de alcance

- Combinar a mano bloques de eventos distintos.
- Calificar la calidad de una sugerencia.

## Preguntas abiertas

- ¿El tamaño estimado también debe contar para decir que dos eventos son similares (por ejemplo, ±50 %)?
- ¿Cuál es la estructura mínima de campos del formulario de inscripción? (viene del PRD)
- ¿Cómo se pondera una edición parcial frente a aceptar el bloque intacto? (viene del PRD)

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
