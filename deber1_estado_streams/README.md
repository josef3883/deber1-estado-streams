# Deber 1 - Manejo de estado y streams en Flutter

## Ejecutar la Parte A

Abra una terminal en `deber1_estado_streams`:

```powershell
flutter pub get
flutter run --dart-define=VERSION=setstate
flutter run --dart-define=VERSION=riverpod
flutter run --dart-define=VERSION=cubit
```

Ejecute un comando run a la vez. Las tres versiones usan `lib/main.dart`,
el mismo contador persistido y las mismas capas domain/data. El valor negativo
está permitido; los botones se desactivan mientras se guarda.

Ramas locales corregidas: `correccion/setstate`, `correccion/riverpod`,
`correccion/cubit`. Cambian sólo la selección en presentation, por lo que
`flutter run` sin define abre la versión de la rama. Cada rama incluye las tres
implementaciones para facilitar la comparación. Las ramas originales se conservaron.

## Ejecutar la Parte B

```powershell
cd parte_b_conexion
flutter pub get
flutter run
```

Es una segunda app Flutter con pestañas Future y Stream. Usa el tipo de conexión
del dispositivo; no comprueba acceso efectivo a Internet. En una PC, apagar Wi-Fi
puede dejar Ethernet activo y mostrar Otra conexión. Use un teléfono/emulador
para mostrar Wi-Fi, datos móviles y ausencia de conexión de forma controlada.

## Arquitectura

- domain: contratos y casos de uso Dart.
- data: implementaciones Dart con operaciones inyectadas, sin plugins.
- presentation: pantallas, Notifier, Cubit y selección de versión.
- main.dart: composición de repositorios y casos de uso; SharedPreferences en A.
- Parte B/infrastructure: único archivo que conoce connectivity_plus.

La Parte B se entrega como archivos normales, no como un gitlink/submódulo.
Así sus fuentes se incluyen al descargar el repositorio.

## Comprobación

```powershell
flutter analyze --no-pub
flutter test --no-pub
cd parte_b_conexion
flutter test --no-pub
```

Las once pruebas usan almacenamiento y eventos de conexión de prueba; no
sustituyen la grabación del dispositivo. Las ocho respuestas, A.5 y A.6 están
en RESPUESTAS.md. Consulte GRABAR_DEMO.md para el video que aún falta.
