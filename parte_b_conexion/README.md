# Parte B - Future y Stream

En esta carpeta: `flutter pub get`, `flutter run`.
Consultar ahora conserva una foto con hora HH:mm:ss. Stream se actualiza
automáticamente y cuenta las transiciones emitidas desde que se abrió.
El contador incluye la transición inicial desde otro si el primer resultado
es distinto. Estados repetidos no lo incrementan.
Las dos pestañas conservan su estado al alternarlas; al desmontarlas se cancela
la escucha. iniciar consulta primero y luego se suscribe, como pide B.3.
Pruebas: `flutter analyze --no-pub`, `flutter test --no-pub`.
El video queda a cargo del estudiante; véase ../GRABAR_DEMO.md.
