---
documento: prd
proyecto: Recomendador de Eventos para Peewah
version: 0.1.3
fecha: 2026-11-06
estado: borrador
autores: [Jhoan Esteban Delgado Mejia, Daniel Felipe Bautista Sánchez, Juan Felipe Castro Reyes, Sebastián Mejía Trujillo, Juan David Meza Castro]
---

# PRD · Recomendador de Eventos para Peewah

## Problema

Los organizadores de eventos recurrentes en Peewah reconstruyen desde cero o configuran manualmente los productos operativos (formularios de inscripción, cronogramas, tareas con responsables y calendarios de comunicación), desaprovechando el historial de decisiones y curvas de asistencia de ediciones pasadas o eventos similares.

## Usuarios

- **Administrador del Evento (Creador / Superusuario)**: Quiere describir las características generales de su nuevo evento y recibir recomendaciones automáticas de configuración operativa y fechas clave de comunicación para tomar decisiones rápidas (aceptar, editar o rechazar).
- **Colaborador / Miembro del Proyecto**: Quiere consultar las configuraciones y recomendaciones generadas para apoyar en la revisión técnica y ejecución de tareas del evento.

## Objetivos

- **O-01** Reducir el tiempo necesario para configurar un nuevo evento recurrente. *Se cumple si* configurar un evento con el recomendador toma menos de 15 minutos.
- **O-02** Proporcionar sugerencias pertinentes de configuración operativa a partir del historial disponible. *Se cumple si* el usuario puede visualizar, evaluar y registrar su decisión (aceptar, editar o rechazar) sobre los bloques recomendados de formulario, cronograma y tareas.
- **O-03** Recomendar el momento oportuno de comunicación con los asistentes. *Se cumple si* el usuario recibe una fecha sugerida para abrir inscripciones y una programación de días para el envío de recordatorios antes del evento.

## Alcance

### Incluye

- Inicio y cierre de sesión de administradores y colaboradores de la organización.
- Visualización de eventos configurados previamente por la organización para utilizarlos como base o referencia.
- Flujo guiado de tres pasos:
  1. Captura de características generales del nuevo evento (nombre, tipo de evento, tamaño estimado, fecha y modalidad presencial, virtual o híbrida).
  2. Generación y visualización de bloques sugeridos (formulario de inscripción, cronograma de actividades y tareas con responsables), con opción individual de aceptar, editar o rechazar cada bloque.
  3. Visualización de recomendaciones de fechas (día para abrir inscripciones y calendario de recordatorios) y confirmación/guardado del evento configurado.
- Motor de envío de correos electrónicos para la comunicación y envío de recordatorios a los inscritos/asistentes (opcional: a implementar solo si hay tiempo; lo obligatorio es sugerir las fechas de los recordatorios).
- Consulta posterior de las recomendaciones y fechas sugeridas una vez configurado el evento.
- Dataset sintético de referencia (3 eventos con múltiples ediciones) integrado con un modelo de IA para generar las sugerencias del MVP.

### No incluye

- Modelos estadísticos nativos en el backend (clustering, k-NN, seasonal decomposition o global forecasting sobre series temporales reales).
- Pasarelas de procesamiento de pagos o gestión de devoluciones a asistentes.
- Edición visual avanzada o personalización gráfica libre de la interfaz de Peewah.

## Restricciones

- **Plazo**: Semana del 25/11/2026.
- **Equipo**: 5 integrantes.
- **Plataformas**: Móvil, escritorio y web.
- **Datos**: Ausencia de acceso directo a la base de datos de producción de Peewah, requiriendo un set de datos sintético inicial.

## Preguntas abiertas

- ¿Cuál es la estructura mínima de campos que debe tener el formulario de inscripción en el MVP?
- ¿Cómo se ponderará si el organizador edita parcialmente una sugerencia frente a si la acepta intacta?

## Historial

- 0.1.3 · 2026-11-06 · Criterio de O-01 ajustado a menos de 15 minutos, restricciones limitadas a plataformas (móvil, escritorio y web), motor de correos marcado como opcional (priorizando fechas de recordatorios), adición de inicio y cierre de sesión de usuarios e inclusión de modalidad híbrida en el flujo guiado.
- 0.1.2 · 2026-11-06 · Inclusión del motor de envío de correos electrónicos en el alcance del MVP.
- 0.1.1 · 2026-11-06 · Actualización de autores y ajuste de fecha límite de entrega (semana del 25/11/2026).
- 0.1.0 · 2026-11-06 · Primera versión borrador creada tras la entrevista inicial de definición del producto.
