# Parte B - Future y Stream

Desde esta carpeta: `flutter pub get`, `flutter run`.

Consultar ahora conserva una foto con hora HH:mm:ss. La otra pestaña escucha
automáticamente los cambios y muestra un contador de transiciones observadas.
El contador incluye la transición inicial desde otro si el primer resultado
es diferente; eventos repetidos con el mismo estado no lo incrementan.
La foto y la escucha se conservan al alternar pestañas y se liberan al desmontar
la app. ConexionCubit inicia una sola suscripción y espera su cancelación al cerrar.

`flutter test --no-pub` comprueba el comportamiento con una fuente simulada.
La demostración física debe grabarse siguiendo ../GRABAR_DEMO.md.
