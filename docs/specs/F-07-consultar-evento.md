---
id: F-07
titulo: Consultar la configuración y las recomendaciones de un evento
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-05, RNF-06]
depende_de: [F-06]
---

# F-07 · Consultar la configuración y las recomendaciones de un evento

## Objetivo

El administrador y los colaboradores consultan, después de guardado el evento, su configuración, qué sugirió el sistema, qué se decidió y qué fechas quedaron.

## Flujo principal

1. El usuario elige un evento configurado en la lista de eventos.
2. El sistema muestra las características del evento.
3. El sistema muestra cada bloque con lo que sugirió el sistema, la decisión (aceptado, editado o rechazado) y, si se editó, el contenido final.
4. El sistema muestra la apertura de inscripciones y los recordatorios, con lo sugerido y lo que quedó.

## Flujos alternos

- **A1 · Colaborador:** el colaborador ve lo mismo que el administrador, sin opciones para cambiar nada.

## Reglas

- Solo pueden verlo los miembros de la organización del evento.
- Esta funcionalidad no cambia nada: solo muestra.

## Estados

- **Cargando:** "Cargando el evento…".
- **Vacío:** si el evento se configuró sin sugerencias, "Este evento se configuró sin sugerencias".
- **Error:** "No se pudo cargar el evento" y la opción de reintentar.

## Datos

- Características del evento; bloques sugeridos con su decisión y su contenido final; apertura de inscripciones y recordatorios, sugeridos y finales.

## Criterios de aceptación

- **CA-1** Dado un evento con un bloque editado, cuando el administrador lo abre, entonces ve el bloque sugerido, la etiqueta "Editado" y el contenido final.
- **CA-2** Dado un colaborador de la organización, cuando abre el evento, entonces ve la misma información y no ve opciones para cambiarla.
- **CA-3** Dado un usuario de otra organización, cuando intenta abrir el evento, entonces ve "No tienes acceso a este evento".
- **CA-4** Dado un evento con un recordatorio editado, cuando se abre, entonces se ve el día sugerido y el día que quedó.
- **CA-5** Dado que no hay conexión, cuando el usuario abre el evento, entonces ve "No se pudo cargar el evento" y puede reintentar.

## Fuera de alcance

- Exportar o imprimir la configuración.

## Preguntas abiertas

- Ninguna por ahora.

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
