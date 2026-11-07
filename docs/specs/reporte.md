# Reporte de specs · Recomendador de Eventos para Peewah

Fecha: 2026-11-06 · Revisado: prd 0.1.4 · requisitos 0.2.0 · spine 0.2.0 · modelo 0.1.0 · 8 specs

## Métricas

- **Completitud** (verde): 15/15 · 100 %
- **Trazabilidad** (verde): RF → objetivo 15/15 · 100 %; spec → RF 8/8 · 100 %
- **Verificabilidad** (verde): 50/50 · 100 %; ninguna spec sin criterios
- **Ambigüedad** (verde): 0
- **Consistencia** (verde): 0 (había 4, corregidas)
- **Atomicidad** (verde): 0
- **Pureza funcional** (verde): 0
- **Preguntas abiertas:** 8 (F-01: 1, F-03: 1, F-04: 3, F-05: 1, F-06: 1, F-08: 1)
- **Avance de implementación:** todo en borrador
- **Estabilidad:** sin cambios mayores; F-02, F-04, F-05, F-06 y F-07 subieron a 0.2.0

## Correcciones aplicadas

### En las specs

1. **F-05 · Reglas.** Decía que la apertura de inscripciones no se podía rechazar, pero RF-13 pide aceptar, editar o rechazar también la apertura. Ahora se puede rechazar y el administrador escribe la suya (CA-7).
2. **F-02 · Reglas.** F-07 dice que el colaborador elige el evento en la lista, pero F-02 solo hablaba del administrador. Ahora los colaboradores ven la lista y el detalle, sin "Usar como base" (CA-6).
3. **F-06 · Flujos alternos.** F-03 guarda las características en el paso 1 y la spine (AD-07) guarda los bloques antes de mostrarlos, pero F-06 decía que salir sin confirmar "no guarda" el evento. Ahora el evento existe "en configuración" desde el paso 1, salir lo descarta, y F-02 solo lista eventos configurados.
4. **F-04 y F-07 · requisitos.** Citaban RNF-06, que pasó a RF-15.

### En los documentos base

5. **architectural_spine 0.2.0 · AD-04.** Decía que la llave de Gemini nunca queda expuesta, pero *Diferido* reconocía que en el MVP va dentro de la app. Ahora AD-04 lo dice tal cual y acepta el riesgo solo para la demostración.
6. **architectural_spine 0.2.0 · AD-09.** Ninguna invariante aislaba las organizaciones y RLS está diferido; F-02 (CA-5) y F-07 (CA-3) lo exigen. Nueva AD-09: toda consulta filtra por la organización del usuario con sesión.
7. **requisitos 0.2.0 · RNF-06 → RF-15.** Registrar la decisión sobre cada bloque es algo que el sistema hace, no una cualidad.
8. **requisitos 0.2.0 · RNF-01.** "Interfaz adaptable" no se podía verificar. Ahora nombra los dispositivos y los anchos de 360 a 1920 píxeles.
9. **prd 0.1.4 · O-02.** El criterio no medía si las sugerencias son pertinentes. Ahora: al menos 2 de 3 bloques aceptados o editados en 7 de cada 10 eventos.
10. **prd 0.1.4 · No incluye.** Nombraba técnicas (k-NN, clustering). Ahora dice "Modelos de predicción entrenados con los datos reales de producción de Peewah".
11. **Repositorio.** Se quitó `.idea/` y se agregó a `.gitignore`.

## Correcciones propuestas

- Ninguna pendiente. Quedan las 8 preguntas abiertas de las specs para que el equipo las responda.

## Lo que está bien

- Todo RF tiene spec y toda spec cita sus RF; F-08 respeta que RF-14 es *Podría*.
- Todos los criterios tienen la forma Dado / cuando / entonces con un resultado que se ve, y cada spec tiene al menos uno de error.
- Las specs cuadran con `docs/modelo.md`: cada dato que nombran tiene su tabla o sale de una (la curva de inscripciones se calcula).
- Ninguna spec nombra tecnología.
