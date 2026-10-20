# Deber 1 - Manejo de estado y streams

## Estructura de entrega

```text
parte_a_contador/
parte_b_conexion/
RESPUESTAS.md
GRABAR_DEMO.md
```

demo.mp4 lo añadirá el estudiante posteriormente. No se realizó push al remoto.

## Ejecutar

Desde la raíz del repositorio, seleccione una versión:

```powershell
git switch version/setstate
cd parte_a_contador
flutter pub get
flutter run
```

Para las otras versiones, vuelva a la raíz y cambie a version/riverpod o
version/bloc. Las tres ramas nacen del mismo commit main y contienen sólo su
presentación. main es la base de domain/data; para usar el contador seleccione
una de las tres ramas. correccion/setstate, correccion/riverpod y correccion/cubit
son alias locales de las versiones revisadas. Las referencias anteriores se
conservaron bajo respaldo/.

Parte B: desde la raíz, `cd parte_b_conexion`, `flutter pub get`, `flutter run`.
Ambas apps usan paquetes y casos de uso separados. Wi-Fi indica una interfaz
de red, no una comprobación de acceso efectivo a Internet.

## Verificación

En cada rama, desde parte_a_contador: `flutter analyze --no-pub` y
`flutter test --no-pub`. Se prueban Volver, flecha, regreso del sistema y la
reconstrucción de la UI con el mismo almacenamiento de prueba.
Desde parte_b_conexion, los mismos comandos comprueban consulta, escucha,
cancelación, cierre con Future pendiente y comportamiento de las pestañas.

RESPUESTAS.md incluye las ocho preguntas, los tres comandos A.5 y la tabla A.6.
REVISION_ENUNCIADO.md explica las diferencias entre rúbrica y enunciado.
