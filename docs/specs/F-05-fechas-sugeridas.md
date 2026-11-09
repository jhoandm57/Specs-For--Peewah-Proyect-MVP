---
id: F-05
titulo: Revisar las fechas sugeridas
version: 0.2.0
fecha: 2026-11-06
estado: implementada
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-11, RF-12, RF-13, RNF-03]
depende_de: [F-03]
---

# F-05 · Revisar las fechas sugeridas

## Objetivo

En el paso 3, el administrador recibe la fecha sugerida para abrir inscripciones y la de cada recordatorio, según cómo se inscribió la gente en eventos similares, y las acepta, edita o rechaza.

## Flujo principal

1. Al abrir el paso 3, el sistema toma la curva de inscripciones de los eventos similares al nuevo (mismo criterio de F-04).
2. El sistema sugiere cuántos días antes del evento abrir las inscripciones y muestra esa fecha.
3. El sistema sugiere los recordatorios, cada uno como días antes del evento, y muestra su fecha.
4. Por la apertura y por cada recordatorio, el administrador elige "Aceptar", "Editar" o "Rechazar".
5. El administrador elige "Siguiente" y pasa a confirmar el evento (F-06).

## Flujos alternos

- **A1 · Sin historial suficiente:** el sistema usa la curva típica de la categoría y avisa "Fechas basadas en la curva típica de un <tipo>".
- **A2 · Editar una fecha:** el administrador cambia los días antes del evento y el sistema actualiza la fecha mostrada.
- **A3 · Rechazar un recordatorio:** el recordatorio se quita de la programación.
- **A4 · La apertura ya pasó:** si la fecha sugerida de apertura es anterior a hoy, el sistema sugiere abrir hoy y lo avisa.

## Reglas

- La apertura de inscripciones es anterior a la fecha del evento y no anterior a hoy.
- Cada recordatorio cae entre la apertura de inscripciones y la fecha del evento.
- Si el administrador rechaza la apertura sugerida, escribe a mano cuántos días antes del evento abrir; no se avanza sin una apertura.
- Se conserva lo sugerido y, aparte, lo que el administrador cambió.
- Si cambia la fecha del evento en el paso 1, las fechas se recalculan con los mismos días antes del evento.
- Las fechas sugeridas aparecen en menos de 10 segundos después de abrir el paso 3 (RNF-03).

## Estados

- **Cargando:** "Calculando fechas…".
- **Vacío:** si no hay curva para la categoría, "No hay fechas sugeridas" y el administrador las escribe a mano.
- **Error:** "No se pudieron calcular las fechas" y la opción de reintentar.

## Datos

- Apertura de inscripciones: días antes del evento, fecha, decisión.
- Recordatorio: días antes del evento, fecha, decisión.
- Curva de inscripciones: inscripciones acumuladas por día antes del evento, de los eventos similares.

## Criterios de aceptación

- **CA-1** Dado un evento el 15 de marzo con apertura sugerida a 30 días, cuando el administrador abre el paso 3, entonces ve "Abrir inscripciones: 13 de febrero (30 días antes)".
- **CA-2** Dado el paso 3, cuando se muestran los recordatorios, entonces cada uno dice cuántos días antes del evento es y su fecha.
- **CA-3** Dado un recordatorio sugerido, cuando el administrador lo edita a un día posterior a la fecha del evento, entonces ve "El recordatorio debe ser antes del evento" y no se guarda.
- **CA-4** Dado un recordatorio sugerido, cuando el administrador elige "Rechazar", entonces ya no aparece en la programación.
- **CA-5** Dado que no hay eventos similares, cuando se abre el paso 3, entonces el administrador ve "Fechas basadas en la curva típica de un <tipo>".
- **CA-6** Dado que la apertura sugerida cae antes de hoy, cuando se abre el paso 3, entonces la apertura sugerida es hoy y el administrador ve el aviso.
- **CA-7** Dado que el administrador rechaza la apertura sugerida, cuando intenta avanzar sin escribir otra, entonces ve "Escribe cuándo abrir las inscripciones" y sigue en el paso 3.
- **CA-8** Dado que no hay conexión, cuando se abre el paso 3, entonces el administrador ve "No se pudieron calcular las fechas" y puede reintentar.

## Fuera de alcance

- Enviar los recordatorios: eso es F-08.
- Escribir el texto de cada recordatorio.

## Preguntas abiertas

- ¿Cuántos recordatorios como máximo puede tener un evento?

## Historial

- 0.2.0 · 2026-11-06 · Tras la crítica: la apertura sugerida ahora sí se puede rechazar, como pide RF-13, y se escribe a mano (CA-7).
- 0.1.0 · 2026-11-06 · Primera versión.
