---
id: F-06
titulo: Confirmar y guardar el evento
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-04, RNF-02]
depende_de: [F-03, F-04, F-05]
---

# F-06 · Confirmar y guardar el evento

## Objetivo

Al final del flujo guiado, el administrador revisa el resumen y guarda el evento con los bloques y las fechas que decidió.

## Flujo principal

1. El sistema muestra el resumen: las características del evento, la decisión y el contenido de cada bloque, la apertura de inscripciones y los recordatorios.
2. El administrador elige "Confirmar evento".
3. El sistema guarda el evento como configurado y muestra "Evento configurado".
4. El sistema abre la consulta del evento (F-07).

## Flujos alternos

- **A1 · Corregir algo:** desde el resumen, el administrador vuelve a cualquier paso, cambia lo que necesita y regresa al resumen.
- **A2 · Salir sin confirmar:** si el administrador intenta salir del flujo, el sistema pregunta "¿Salir sin guardar? Se perderá lo que no confirmaste"; si confirma, el evento no se guarda.

## Reglas

- Solo se confirma un evento con los tres pasos completos.
- Un bloque rechazado se guarda vacío.
- Al confirmar, el evento aparece en la lista de eventos de la organización (F-02).
- Un administrador que acepta todas las sugerencias termina el flujo, del paso 1 a "Confirmar evento", en menos de 15 minutos (RNF-02).

## Estados

- **Cargando:** "Guardando evento…".
- **Vacío:** no aplica: el resumen siempre tiene los datos del paso 1.
- **Error:** "No se pudo guardar el evento" y la opción de reintentar; nada de lo decidido se pierde.

## Datos

- Evento con sus características, sus bloques con su decisión, la apertura de inscripciones, los recordatorios y su estado (configurado).

## Criterios de aceptación

- **CA-1** Dado el resumen completo, cuando el administrador elige "Confirmar evento", entonces ve "Evento configurado" y la consulta del evento.
- **CA-2** Dado un evento confirmado, cuando el administrador abre la lista de eventos, entonces lo ve en la lista.
- **CA-3** Dado el resumen, cuando el administrador vuelve al paso 2 y cambia una decisión, entonces el resumen muestra la decisión nueva.
- **CA-4** Dado el paso 3, cuando el administrador intenta salir y confirma "Salir sin guardar", entonces el evento no aparece en la lista.
- **CA-5** Dado un administrador que acepta todas las sugerencias, cuando hace el flujo completo, entonces llega a "Evento configurado" en menos de 15 minutos.
- **CA-6** Dado que no hay conexión, cuando el administrador confirma, entonces ve "No se pudo guardar el evento" y el resumen sigue igual.

## Fuera de alcance

- Publicar el evento o abrir las inscripciones al público.
- Guardar un evento a medias como borrador.

## Preguntas abiertas

- ¿Un evento configurado se puede volver a editar, o queda fijo?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
