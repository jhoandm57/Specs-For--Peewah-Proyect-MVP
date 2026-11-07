# Reporte de specs · Recomendador de Eventos para Peewah

Fecha: 2026-11-06 · Revisado: prd 0.1.3 · requisitos 0.1.1 · spine 0.1.0 · 8 specs

## Métricas

- **Completitud** (verde): 14/14 · 100 %
- **Trazabilidad** (verde): RF → objetivo 14/14 · 100 %; spec → RF 8/8 · 100 %
- **Verificabilidad** (verde): 50/50 · 100 %; ninguna spec sin criterios
- **Ambigüedad** (verde): 0
- **Consistencia** (verde): 0 dentro de las specs (había 2, corregidas); hay 1 en la spine, ver *Correcciones propuestas*
- **Atomicidad** (verde): 0
- **Pureza funcional** (verde): 0
- **Preguntas abiertas:** 8 (F-01: 1, F-03: 1, F-04: 3, F-05: 1, F-06: 1, F-08: 1)
- **Avance de implementación:** todo en borrador
- **Estabilidad:** sin cambios mayores; F-02 y F-05 subieron a 0.2.0 por la crítica

## Correcciones aplicadas

1. **F-05 · Reglas.** Decía que la apertura de inscripciones no se podía rechazar, pero RF-13 pide aceptar, editar o rechazar también la apertura. Ahora se puede rechazar y el administrador escribe la suya; se agregó CA-7.
2. **F-02 · Reglas.** F-07 dice que el colaborador elige el evento en la lista, pero F-02 solo hablaba del administrador. Ahora los colaboradores ven la lista y el detalle, sin "Usar como base"; se agregó CA-6.

## Correcciones propuestas

Estas tocan documentos de otros integrantes; las deja anotadas para que el equipo decida.

1. **architectural_spine 0.1.0 · AD-04 frente a *Diferido*.** AD-04 dice que la llave de Gemini nunca queda expuesta, pero *Diferido* dice que en el MVP viaja dentro de la app. Leerla de un archivo de configuración la mete igual en el build. Propuesta: que AD-04 lo diga tal cual ("en el MVP la llave de Gemini va en la app; se acepta el riesgo hasta moverla a una Edge Function") o mover la llamada ya.
2. **architectural_spine 0.1.0 · Invariantes.** Ninguna dice que cada organización solo ve sus datos, y RLS está diferido. F-02 (CA-5) y F-07 (CA-3) lo exigen. Propuesta: AD-09 · "Toda consulta filtra por la organización del usuario con sesión".
3. **requisitos 0.1.1 · RNF-06.** Registrar la decisión sobre cada bloque es algo que el sistema hace, no una cualidad: es un RF. Propuesta: pasarlo a RF.
4. **requisitos 0.1.1 · RNF-01.** "Interfaz adaptable" no tiene número. Propuesta: nombrar los tamaños o dispositivos donde se va a probar.
5. **prd 0.1.3 · O-02.** El criterio dice que el usuario puede decidir, pero no mide si las sugerencias son pertinentes. Propuesta: "el administrador acepta o edita al menos 2 de los 3 bloques en 7 de cada 10 eventos".
6. **prd 0.1.3 · No incluye.** Nombra técnicas (k-NN, clustering, forecasting). Propuesta: "Modelos de predicción entrenados con datos reales de Peewah".
7. **Repositorio.** La carpeta `.idea/` del IDE está en el repo. Propuesta: agregarla a `.gitignore` y quitarla con `git rm -r --cached .idea`.

## Lo que está bien

- Todo RF tiene spec y toda spec cita sus RF; F-08 respeta que RF-14 es *Podría*.
- Todos los criterios tienen la forma Dado / cuando / entonces con un resultado que se ve, y cada spec tiene al menos uno de error.
- Las specs siguen AD-07 de la spine: cada bloque se guarda con decisión pendiente antes de mostrarse.
- Ninguna spec nombra tecnología.
