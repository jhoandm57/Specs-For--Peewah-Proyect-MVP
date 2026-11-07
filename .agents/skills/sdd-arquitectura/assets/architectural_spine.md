---
documento: architectural_spine
proyecto: Nombre del proyecto
version: 0.1.0
fecha: AAAA-MM-DD
estado: borrador
basado_en: [prd 0.1.0, requisitos 0.1.0]
---

# Architectural spine · Nombre del proyecto

## Resumen

Tres líneas: qué es la app, dónde corre y con qué backend.

## Diagrama

```mermaid
flowchart LR
  user([Usuario]) --> app[App Flutter]
  app --> services[Capa de servicios]
  services --> sdk[supabase_flutter]
  sdk --> auth[Auth]
  sdk --> db[(Base de datos · PostgREST)]
  sdk --> storage[[Storage]]