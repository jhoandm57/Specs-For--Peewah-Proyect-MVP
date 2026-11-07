---
documento: requisitos
proyecto: Recomendador de Eventos para Peewah
version: 0.2.0
fecha: 2026-11-06
estado: borrador
basado_en: prd 0.1.4
---

# Requisitos · Recomendador de Eventos para Peewah

## Funcionales

### O-01 · Reducir el tiempo necesario para configurar un nuevo evento recurrente

- **RF-01** El sistema debe permitir que administradores y colaboradores inicien y cierren sesión en su organización. *Debe*
- **RF-02** El sistema debe permitir que el administrador consulte el listado de eventos configurados previamente por su organización. *Debe*
- **RF-03** El sistema debe permitir que el administrador registre las características iniciales del nuevo evento (nombre, tipo de evento, tamaño estimado, fecha y modalidad presencial, virtual o híbrida). *Debe*
- **RF-04** El sistema debe permitir que el administrador confirme y guarde la configuración final del nuevo evento tras completar el flujo guiado. *Debe*
- **RF-05** El sistema debe permitir que colaboradores y administradores consulten la configuración y las recomendaciones del evento una vez guardado. *Debe*

### O-02 · Proporcionar sugerencias pertinentes de configuración operativa a partir del historial disponible

- **RF-06** El sistema debe sugerir un formulario de inscripción a partir de eventos similares de la organización o, si no hay historial suficiente, de la configuración típica de la categoría. *Debe*
- **RF-07** El sistema debe sugerir un cronograma de actividades a partir de eventos similares de la organización o, si no hay historial suficiente, de la configuración típica de la categoría. *Debe*
- **RF-08** El sistema debe sugerir las tareas operativas con responsables a partir de eventos similares de la organización o, si no hay historial suficiente, de la configuración típica de la categoría. *Debe*
- **RF-09** El sistema debe permitir que el administrador evalúe y registre su decisión individual (aceptar, editar o rechazar) para cada bloque sugerido de formulario, cronograma y tareas. *Debe*
- **RF-10** El sistema debe permitir que el administrador modifique los elementos de cualquier bloque sugerido cuando decida editarlo. *Debe*
- **RF-15** El sistema debe registrar la decisión del administrador sobre cada bloque sugerido (aceptado, editado o rechazado) y conservarla para consultarla después. *Debe*

### O-03 · Recomendar el momento oportuno de comunicación con los asistentes

- **RF-11** El sistema debe sugerir la fecha para abrir inscripciones a partir de las curvas históricas de eventos similares o, si no hay historial suficiente, de la curva típica de la categoría. *Debe*
- **RF-12** El sistema debe sugerir la fecha de envío de cada recordatorio a partir de las curvas históricas de eventos similares o, si no hay historial suficiente, de la programación típica de la categoría. *Debe*
- **RF-13** El sistema debe permitir que el administrador acepte, edite o rechace las fechas recomendadas de apertura de inscripciones y recordatorios. *Debe*
- **RF-14** El sistema debe permitir el envío automático de correos electrónicos de recordatorio a los asistentes inscritos en las fechas programadas. *Podría*

## No funcionales

- **RNF-01** El sistema funciona en un teléfono Android, en un computador de escritorio y en un navegador web, y en anchos de pantalla de 360 a 1920 píxeles se ve completo sin desplazamiento horizontal. (O-01) *Debe*
- **RNF-02** El flujo guiado de configuración de un evento debe completarse en menos de 15 minutos. (O-01) *Debe*
- **RNF-03** El sistema debe presentar la configuración sugerida y las fechas recomendadas en un tiempo inferior a 10 segundos tras recibir las características del evento. (O-02) *Debe*
- **RNF-04** El sistema debe restringir el acceso a la información y gestión de la organización exclusivamente a usuarios autenticados. (O-01) *Debe*
- **RNF-05** El sistema debe contar con un conjunto inicial de datos de referencia de al menos 3 eventos con al menos 2 ediciones cada uno para generar las sugerencias. (O-02) *Debe*

## Preguntas abiertas

- ¿Cuál es la estructura mínima de campos que debe tener el formulario de inscripción en el MVP?
- ¿Cómo se ponderará si el organizador edita parcialmente una sugerencia frente a si la acepta intacta?

## Historial

- 0.2.0 · 2026-11-06 · RNF-06 pasa a RF-15 (es algo que el sistema hace, no una cualidad) y RNF-01 queda con dispositivos y anchos que se pueden probar, según el reporte de la crítica.
- 0.1.1 · 2026-11-06 · Redacción de RF-06, RF-07, RF-08, RF-11 y RF-12 con "El sistema debe sugerir...", adición de opción de rechazo en RF-13, ajuste de RNF-05 (al menos 3 eventos con al menos 2 ediciones cada uno) y simplificación de RNF-06 registrando decisiones sin curva final.
- 0.1.0 · 2026-11-06 · Primera versión borrador de requisitos basada en el PRD 0.1.3.
