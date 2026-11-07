---
id: F-02
titulo: Consultar eventos anteriores
version: 0.2.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-02]
depende_de: [F-01]
---

# F-02 · Consultar eventos anteriores

## Objetivo

El administrador ve los eventos que su organización ya configuró, para usar uno como base o referencia del nuevo evento.

## Flujo principal

1. El administrador entra a la lista de eventos de su organización.
2. El sistema muestra cada evento con su nombre, tipo, modalidad, tamaño estimado y fecha, del más reciente al más antiguo.
3. El administrador elige un evento.
4. El sistema muestra su formulario de inscripción, su cronograma de actividades y sus tareas con responsables.

## Flujos alternos

- **A1 · Usarlo como base:** desde el detalle, el administrador elige "Usar como base"; el sistema abre el paso 1 de F-03 con el tipo, la modalidad y el tamaño de ese evento ya llenos.
- **A2 · Filtrar por tipo:** el administrador elige un tipo de evento y la lista muestra solo los de ese tipo.

## Reglas

- Solo se muestran eventos de la organización del usuario con sesión.
- Los colaboradores también ven la lista y el detalle, pero sin la opción "Usar como base".
- Solo se listan eventos configurados (F-06); los que están en configuración no aparecen.
- Los eventos del conjunto de datos de referencia (RNF-05) se muestran como eventos de su organización.

## Estados

- **Cargando:** "Cargando eventos…".
- **Vacío:** "Tu organización todavía no tiene eventos" y la opción de crear uno nuevo (F-03).
- **Error:** "No se pudieron cargar los eventos" y la opción de reintentar.

## Datos

- Evento: nombre, tipo, modalidad (presencial, virtual o híbrida), tamaño estimado, fecha, formulario de inscripción, cronograma de actividades y tareas con responsables.

## Criterios de aceptación

- **CA-1** Dado que la organización tiene 3 eventos, cuando el administrador abre la lista, entonces ve los 3 ordenados del más reciente al más antiguo.
- **CA-2** Dado un evento en la lista, cuando el administrador lo elige, entonces ve su formulario, su cronograma y sus tareas.
- **CA-3** Dado el detalle de un evento, cuando el administrador elige "Usar como base", entonces el paso 1 de F-03 aparece con el tipo, la modalidad y el tamaño de ese evento.
- **CA-4** Dado que hay eventos de dos tipos, cuando el administrador filtra por uno, entonces solo ve los eventos de ese tipo.
- **CA-5** Dado un usuario de la organización A, cuando abre la lista, entonces no ve ningún evento de la organización B.
- **CA-6** Dado un colaborador, cuando abre el detalle de un evento, entonces ve el formulario, el cronograma y las tareas, y no ve "Usar como base".
- **CA-7** Dado que la organización no tiene eventos, cuando el administrador abre la lista, entonces ve "Tu organización todavía no tiene eventos".
- **CA-8** Dado que no hay conexión, cuando el administrador abre la lista, entonces ve "No se pudieron cargar los eventos" y puede reintentar.

## Fuera de alcance

- Editar o borrar un evento anterior.

## Preguntas abiertas

- Ninguna por ahora.

## Historial

- 0.2.0 · 2026-11-06 · Tras la crítica: los colaboradores también ven la lista, sin "Usar como base" (CA-6), para que F-07 sea alcanzable por ellos; solo se listan eventos configurados, para cuadrar con F-06.
- 0.1.0 · 2026-11-06 · Primera versión.
