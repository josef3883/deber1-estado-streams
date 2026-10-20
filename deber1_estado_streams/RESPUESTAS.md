# RESPUESTAS - Deber 1: estado y streams

Se conserva la numeración de las ocho respuestas originales. Los títulos resumen
su tema; no se recibió el enunciado con las preguntas literales. La comprobación
de comportamiento se hizo con pruebas automatizadas y repositorios de prueba;
la grabación con un cambio real de conexión sigue pendiente.

## 1. Persistencia y pantalla desactualizada con setState

Guardar el contador no reconstruye automáticamente el visor. En esta versión,
el visor lee el valor inicial, lo envía al control por `valorInicial` y espera
el resultado de `Navigator.push<int>`. El botón Volver devuelve el nuevo valor
con `Navigator.pop<int>(context, _valor)`; entonces el visor llama a setState.
La flecha de AppBar puede devolver null: en ese caso el visor vuelve a leer el
repositorio. Se verificaron ambos caminos empezando en 3, sumando, restando y
regresando con 4; al reconstruir la aplicación, el almacenamiento de prueba
conservó 4. Esto distingue el dato persistido de la copia que dibuja la UI.

## 2. Qué cambia con Riverpod y Cubit

Las dos pantallas leen la misma fuente de estado. Riverpod declara
`contadorProvider` fuera del árbol y coloca un ProviderScope por encima de
MaterialApp/Navigator. Cubit sitúa BlocProvider en ese mismo nivel. El control
no recibe el contador ni lo devuelve al visor: sólo se navega sin argumentos
de datos. Al volver, la pantalla muestra 4 porque observa el estado compartido.
Los casos de uso llegan desde main y presentación no construye repositorios.

## 3. Qué aporta BlocObserver

El observer permite observar las transiciones desde un punto central. La prueba
y la consola mostraron `ContadorCubit: 3 -> 4`. RegistroContador omite los cambios
que sólo alteran ocupado/error y registra cuando cambia el valor. El estado
es un objeto ContadorEstado con campos final; cada emisión crea un objeto nuevo.

## 4. Qué demuestran los git diff (A.5)

Desde `deber1_estado_streams`, después de crear las ramas corregidas:

```text
$ git diff correccion/setstate correccion/riverpod -- lib/domain lib/data
[sin salida; código de salida 0]
$ git diff correccion/riverpod correccion/cubit -- lib/domain lib/data
[sin salida; código de salida 0]
```

Los dos diffs vacíos demuestran que cambiar la presentación no modifica el
núcleo. Las tres implementaciones están en presentation y la selección
predeterminada de cada rama está en `presentation/seleccion.dart`. Main y los
casos de uso son idénticos. También se pueden ejecutar desde una sola rama:

```powershell
flutter run --dart-define=VERSION=setstate
flutter run --dart-define=VERSION=riverpod
flutter run --dart-define=VERSION=cubit
```

El diff por sí solo no prueba la dirección de dependencias: se comprobó además
que domain y data no importan Flutter ni paquetes externos y que presentation
no importa shared_preferences ni connectivity_plus. El almacenamiento se
inyecta en main y el plugin de conexión queda en infrastructure.

## 5. Elección y tabla comparativa (A.6)

Para este contador pequeño, setState resuelve el caso con pocos conceptos.
Con ocho pantallas y cinco datos compartidos elegiría Riverpod para evitar
propagar copias y resultados entre rutas. Cubit también es adecuado cuando se
quieren transiciones explícitas y observación centralizada.

| Aspecto observado | setState | Riverpod | Cubit |
| --- | --- | --- | --- |
| Dueño del estado | Cada StatefulWidget | Notifier del provider | ContadorCubit |
| Lectura en UI | Campo local | ref.watch | BlocBuilder |
| Acción | Método y setState | ref.read(...notifier) | context.read<ContadorCubit> |
| Datos entre rutas | Constructor + resultado de pop | No se pasa el contador | No se pasa el contador |
| Regreso con flecha | Releer si el resultado es null | Observa estado compartido | Observa estado compartido |
| Evitar pulsaciones durante escritura | Bandera local | Estado ocupado | Estado ocupado |
| Registro central | No incorporado | No incorporado aquí | BlocObserver, 3 -> 4 |
| Núcleo | Mismos casos de uso y data | Sin cambios | Sin cambios |

## 6. Por qué Future no cambia solo

En la prueba de la Parte B, Consultar ahora muestra Wi-Fi y una hora HH:mm:ss.
Se pasa a Stream y el repositorio de prueba emite sinConexion: esa pestaña
cambia sin pulsar consultar. Al volver a Future todavía se ve Wi-Fi; sólo
otra consulta lo cambia a Sin conexión. AutomaticKeepAliveClientMixin conserva
la foto entre pestañas. El Future terminó y no quedó una escucha activa.
Esta prueba usa eventos simulados; no acredita cambios físicos del Wi-Fi.

## 7. Por qué cancelar la suscripción

Sin cancelación, el origen puede seguir notificando a un Cubit cerrado y
mantener recursos activos. `close()` espera `await _suscripcion?.cancel()` antes
de `super.close()`. La prueba contó una escucha aunque iniciar se invocó dos
veces y una cancelación al cerrar. También se probó cerrar con una consulta
pendiente: su resultado tardío no emite después del cierre. Otro caso verifica
que una consulta antigua no sobrescriba un evento más reciente del stream.

## 8. Future como foto y Stream como secuencia

El experimento de las pestañas hace visible la diferencia: Future conserva
el resultado de una consulta, Stream recibe cambios sucesivos mientras escucha.
Usaría Future para enviar un formulario o cargar un catálogo una vez; Stream
para mensajes entrantes de un chat o una ubicación que cambia durante un viaje.
En esta app se informa del tipo de conexión de red. Wi-Fi no garantiza acceso
a Internet y el estado otro puede corresponder, por ejemplo, a Ethernet.

## Evidencia y pendiente de entrega

- Parte A: siete pruebas aprobadas (seis de navegación/persistencia y una del observer).
- Parte B: cuatro pruebas aprobadas (suscripción, consulta tardía, cierre y pestañas).
- `flutter analyze --no-pub`: sin incidencias en el proyecto completo.
- Falta `demo.mp4` con un cambio real de conexión. Instrucciones en `GRABAR_DEMO.md`.
- No se ha subido esta corrección al remoto. Las ramas `version/*` originales se conservan.
