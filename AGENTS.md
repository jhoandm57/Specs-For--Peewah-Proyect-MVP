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