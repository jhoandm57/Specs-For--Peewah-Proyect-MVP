# AGENTS.md · Recomendador de Eventos para Peewah

## Qué es la app

Un recomendador para Peewah que, en un flujo guiado de tres pasos, ayuda al administrador
de un evento recurrente a configurarlo: describe el evento, recibe bloques sugeridos
(formulario, cronograma y tareas) que acepta, edita o rechaza, y recibe las fechas
sugeridas para abrir inscripciones y enviar recordatorios. Es el MVP del curso Seminario
de Ingeniería de Software (Icesi), con entrega la semana del 25/11/2026.

## Contexto

Peewah es una plataforma para crear y gestionar eventos. Las organizaciones que hacen
eventos de forma recurrente, como un congreso anual, una feria o un seminario, suelen
repetir en cada edición decisiones que ya tomaron antes: qué formulario de inscripción
usar, cómo armar el cronograma, qué tareas asignar y cuándo abrir inscripciones o enviar
recordatorios. Hoy Peewah permite clonar manualmente un evento pasado, pero no ayuda
a decidir cuál reutilizar, cómo combinar varias ediciones ni cuándo comunicarse con los
inscritos. Así, el historial acumulado se aprovecha poco y el organizador reconstruye cada
edición casi desde cero.
Esta propuesta añade a Peewah un recomendador en tres pasos. El organizador describe
su nuevo evento (tipo, tamaño y modalidad), recibe una configuración sugerida a partir de
eventos propios similares y obtiene una sugerencia de cuándo abrir inscripciones y enviar
recordatorios, según la curva histórica de inscripciones. Si la organización no tiene
historial suficiente, el sistema usa la configuración típica de la categoría del evento. Cada
bloque de la recomendación puede aceptarse, editarse o rechazarse, y al cerrar el evento
su configuración y su curva real de inscripciones quedan como nuevo historial.
Para esto la aplicación guarda las organizaciones y sus usuarios, los eventos con su
categoría, modalidad, tamaño y fecha, y el evento del que se parte cuando se clona. De
cada evento guarda su formulario, cronograma y tareas con responsables. También guarda
las inscripciones, con los datos de cada asistente y sus respuestas al formulario; de la
fecha de cada inscripción sale la curva de inscripciones acumuladas por días antes del
evento. Por último guarda las recomendaciones generadas, la decisión del organizador
sobre cada bloque (aceptado, editado o rechazado), la fecha sugerida para abrir
inscripciones y los recordatorios.

## Estructura actual

El prototipo Flutter se encuentra en el subdirectorio app/. Su punto de entrada es
app/lib/main.dart y las plataformas generadas son Android, web y Windows.
Los documentos del proyecto están en docs/ y las skills de SDD en .agents/skills/.

## Documentos

`docs/` tiene los documentos del proyecto, en este orden. Cada uno se basa en los
anteriores: léelos antes de proponer o escribir código.

1. `docs/prd.md` · el problema, los usuarios, los objetivos (`O-01`…) y el alcance.
2. `docs/requisitos.md` · los requisitos (`RF-01`…, `RNF-01`…), cada uno ligado a un objetivo.
3. `docs/architectural_spine.md` · las reglas de arquitectura (`AD-01`…) que todos siguen.
4. `docs/modelo.md` · las tablas, sus atributos y relaciones, con el diagrama.
5. `docs/specs/` · una spec por funcionalidad (`F-01`…), su índice `README.md` y el `reporte.md` de la crítica.

Para implementar una funcionalidad, lee su spec y las invariantes de la spine que toca.
Al terminarla, cambia su `estado` a `implementada` y actualiza el índice.
Si un cambio contradice uno de estos documentos, dilo antes de hacerlo; no lo cambies en silencio.
