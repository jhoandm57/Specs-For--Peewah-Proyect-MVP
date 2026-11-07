---
id: F-08
titulo: Enviar recordatorios por correo
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-14]
depende_de: [F-05, F-06]
---

# F-08 · Enviar recordatorios por correo

## Objetivo

Los inscritos de un evento configurado reciben por correo cada recordatorio el día programado, sin que el administrador lo envíe a mano. Es *Podría*: se implementa solo si hay tiempo.

## Flujo principal

1. Llega el día de un recordatorio programado de un evento configurado.
2. El sistema envía un correo a cada inscrito con el nombre, la fecha y la modalidad del evento.
3. El sistema marca el recordatorio como enviado, con la fecha y el número de correos enviados.

## Flujos alternos

- **A1 · Sin inscritos:** si el evento no tiene inscritos ese día, el recordatorio se marca como "Sin destinatarios" y no se envía nada.
- **A2 · Correo que falla:** si un correo no se puede entregar, el sistema lo reintenta una vez; si vuelve a fallar, lo anota como fallido.

## Reglas

- Solo se envían recordatorios de eventos configurados (F-06).
- Un recordatorio rechazado en F-05 no se envía.
- Cada inscrito recibe un solo correo por recordatorio.

## Estados

- **Cargando:** no aplica: ningún usuario espera el envío.
- **Vacío:** el administrador ve "Sin destinatarios" en el recordatorio (A1).
- **Error:** el administrador ve en la consulta del evento (F-07) cuántos correos fallaron.

## Datos

- Recordatorio: fecha, estado (pendiente, enviado o sin destinatarios), correos enviados y fallidos.
- Inscrito: nombre y correo electrónico.

## Criterios de aceptación

- **CA-1** Dado un evento configurado con 50 inscritos y un recordatorio para hoy, cuando pasa el día, entonces los 50 reciben un correo y el recordatorio dice "Enviado · 50".
- **CA-2** Dado un recordatorio rechazado en F-05, cuando llega su día, entonces no se envía ningún correo.
- **CA-3** Dado un recordatorio para hoy y ningún inscrito, cuando pasa el día, entonces el recordatorio dice "Sin destinatarios".
- **CA-4** Dado un correo que falla dos veces, cuando el administrador consulta el evento, entonces ve "1 correo fallido" en ese recordatorio.

## Fuera de alcance

- Que el administrador redacte el texto del correo.
- Otros canales, como mensajes de texto.

## Preguntas abiertas

- ¿El texto del correo es fijo o cambia según el tipo de evento?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
