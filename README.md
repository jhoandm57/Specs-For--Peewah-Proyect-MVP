# Peewah · Prototipo Flutter

Prototipo navegable para configurar eventos recurrentes. La sesión, el historial y las recomendaciones usan datos simulados. Los cambios de eventos se guardan en memoria durante la sesión.

## Probar en el navegador

[**Abrir Peewah en localhost**](http://localhost:8080/)

El enlace funciona en el equipo que está ejecutando el servidor. Si el servidor está apagado, ejecuta estos comandos desde la raíz del repositorio y deja la terminal abierta.

```powershell
cd app
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

En el inicio de sesión, elige el acceso rápido **Administrador** para probar el asistente completo y confirmar un evento.

## Video de demostración

[Ver el recorrido en PC (MP4, 1:35)](docs/peewah-recorrido-pc.mp4)

Muestra el inicio de sesión, la consulta del historial y el detalle, los tres pasos del asistente y el evento confirmado en la lista.

## Documentación

- [Especificaciones funcionales](docs/specs/README.md)
- [Modelo de datos](docs/modelo.md)
