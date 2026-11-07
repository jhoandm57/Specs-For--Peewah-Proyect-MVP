---
id: F-01
titulo: Iniciar y cerrar sesión
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Juan Felipe Castro Reyes]
requisitos: [RF-01, RNF-04]
depende_de: []
---

# F-01 · Iniciar y cerrar sesión

## Objetivo

Administradores y colaboradores entran a la app con su cuenta y quedan dentro de su organización; al salir, nadie más puede ver los datos desde ese dispositivo.

## Flujo principal

1. El usuario abre la app sin sesión y ve el inicio de sesión.
2. Escribe su correo y su contraseña y elige "Iniciar sesión".
3. El sistema valida las credenciales.
4. El sistema muestra la lista de eventos de la organización del usuario (F-02).

## Flujos alternos

- **A1 · Credenciales incorrectas:** el sistema muestra "Correo o contraseña incorrectos" y el usuario sigue en el inicio de sesión.
- **A2 · Cerrar sesión:** desde cualquier parte de la app, el usuario elige "Cerrar sesión"; el sistema termina la sesión y vuelve al inicio de sesión.
- **A3 · Sesión guardada:** si el usuario no cerró sesión, al volver a abrir la app entra directo a la lista de eventos.

## Reglas

- Sin sesión, el usuario solo puede ver el inicio de sesión.
- Cada usuario pertenece a una sola organización y tiene un rol: administrador o colaborador.
- El rol decide qué puede hacer: solo el administrador configura eventos (F-03 a F-06).

## Estados

- **Cargando:** "Iniciando sesión…" mientras se validan las credenciales.
- **Vacío:** el inicio de sesión abre con el correo y la contraseña en blanco.
- **Error:** sin conexión, "No se pudo conectar. Revisa tu conexión" y los datos escritos se conservan.

## Datos

- Usuario: correo, contraseña, organización, rol (administrador o colaborador).

## Criterios de aceptación

- **CA-1** Dado un administrador con cuenta, cuando escribe su correo y su contraseña correctos, entonces ve la lista de eventos de su organización.
- **CA-2** Dado un usuario, cuando escribe una contraseña incorrecta, entonces ve "Correo o contraseña incorrectos" y sigue en el inicio de sesión.
- **CA-3** Dado un usuario con sesión, cuando elige "Cerrar sesión", entonces vuelve al inicio de sesión y al abrir la app de nuevo no ve los eventos.
- **CA-4** Dado un colaborador con sesión, cuando entra a la app, entonces no ve la opción "Nuevo evento".
- **CA-5** Dado que no hay conexión, cuando el usuario elige "Iniciar sesión", entonces ve "No se pudo conectar. Revisa tu conexión".

## Fuera de alcance

- Registrarse desde la app o recuperar la contraseña.
- Pertenecer a más de una organización.

## Preguntas abiertas

- ¿Quién crea las cuentas de los usuarios en el MVP? ¿Vienen cargadas con el conjunto de datos de referencia?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
