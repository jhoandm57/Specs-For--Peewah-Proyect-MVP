---
id: F-03
titulo: Describir el nuevo evento
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-03]
depende_de: [F-01]
---

# F-03 · Describir el nuevo evento

## Objetivo

El administrador empieza el flujo guiado de tres pasos y, en el paso 1, describe el nuevo evento para que el sistema pueda sugerirle una configuración.

## Flujo principal

1. El administrador elige "Nuevo evento".
2. El sistema muestra el flujo guiado con sus tres pasos (1 · Características, 2 · Bloques sugeridos, 3 · Fechas sugeridas) y abre el paso 1.
3. El administrador escribe el nombre y elige el tipo de evento, el tamaño estimado de asistentes, la fecha y la modalidad (presencial, virtual o híbrida).
4. El administrador elige "Siguiente".
5. El sistema guarda las características y abre el paso 2 (F-04).

## Flujos alternos

- **A1 · Falta un dato:** si un campo está vacío, el sistema marca ese campo con "Este dato es obligatorio" y no avanza.
- **A2 · Fecha pasada:** si la fecha es anterior a hoy, el sistema muestra "La fecha del evento debe ser futura" y no avanza.
- **A3 · Volver:** desde el paso 2 o el 3, el administrador vuelve al paso 1 y ve los datos que ya había escrito.

## Reglas

- Los cinco datos son obligatorios.
- El tamaño estimado es un número entero mayor que 0.
- El tipo de evento se elige de una lista cerrada de categorías.
- El administrador puede moverse entre pasos ya visitados sin perder lo que escribió.
- Solo el administrador puede crear eventos.

## Estados

- **Cargando:** al elegir "Siguiente", "Guardando…" mientras se guardan las características.
- **Vacío:** el paso 1 abre con los campos en blanco, salvo que venga de "Usar como base" (F-02, A1).
- **Error:** "No se pudo guardar. Revisa tu conexión" y los datos escritos se conservan.

## Datos

- Nombre del evento, tipo de evento, tamaño estimado de asistentes, fecha del evento, modalidad.

## Criterios de aceptación

- **CA-1** Dado el paso 1 con los cinco datos llenos, cuando el administrador elige "Siguiente", entonces ve el paso 2.
- **CA-2** Dado el paso 1 sin la modalidad, cuando el administrador elige "Siguiente", entonces ve "Este dato es obligatorio" junto a la modalidad y sigue en el paso 1.
- **CA-3** Dado una fecha de ayer, cuando el administrador elige "Siguiente", entonces ve "La fecha del evento debe ser futura".
- **CA-4** Dado que el administrador está en el paso 2, cuando vuelve al paso 1, entonces ve el nombre, el tipo, el tamaño, la fecha y la modalidad que había escrito.
- **CA-5** Dado que el administrador elige "Nuevo evento", cuando se abre el flujo, entonces ve los tres pasos y el paso 1 marcado como actual.
- **CA-6** Dado que no hay conexión, cuando el administrador elige "Siguiente", entonces ve "No se pudo guardar. Revisa tu conexión" y sus datos siguen en el formulario.

## Fuera de alcance

- Generar las sugerencias: eso es F-04.
- Crear categorías de evento nuevas.

## Preguntas abiertas

- ¿Cuál es la lista de tipos de evento del MVP (congreso, feria, seminario…)?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
