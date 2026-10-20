# RESPUESTAS - Deber 1

Preguntas contrastadas con el enunciado Deber1.md. Las observaciones de esta
revisión proceden de pruebas automatizadas con repositorios de prueba. La prueba
física del dispositivo y el video los realizará el estudiante posteriormente.

## 1. ¿Qué pasó al volver con el botón atrás del sistema y por qué? ¿Qué quedó desactualizado y cuántos lugares debían ponerse de acuerdo?

En la implementación mínima que depende exclusivamente del resultado de pop,
el botón del sistema regresa sin ese resultado: el valor se guarda en disco,
pero queda desactualizada la copia del contador en el State del visor. No falla
la persistencia. Hay tres puntos que deben coordinar el viaje del dato: el
constructor del control recibe el valor; el control devuelve el resultado con
Navigator.pop; el visor espera ese resultado y llama a setState.

En la entrega corregida se añadió una protección: si la ruta vuelve con null,
el visor vuelve a leer el repositorio. Por eso el fallo deliberado del ejercicio
ya no se reproduce en la versión final. Se probaron el botón Volver, la flecha
y el evento de regreso del sistema: los tres muestran 4 tras modificar un 3;
al reconstruir la UI con el mismo almacenamiento de prueba se conserva 4.

## 2. ¿Por qué el botón atrás del sistema no rompe nada con Riverpod? ¿Dónde vive el contador?

El contador vive en ContadorNotifier, dentro del contenedor de Riverpod, por
encima del Navigator. Ambas pantallas observan el mismo provider, declarado
fuera del árbol. El control actualiza ese estado mediante los casos de uso y
no devuelve el contador al navegar. El visor ya observa el nuevo valor, incluso
si se vuelve con el botón del sistema. Se comprobó con la misma secuencia de
navegación usada para setState. Cubit resuelve el caso compartiendo una instancia
de ContadorCubit por encima de ambas rutas.

## 3. ¿Qué permite ver BlocObserver y en qué situación real es útil?

Permite ver desde un punto central la secuencia de transiciones, por ejemplo
`ContadorCubit: 3 -> 4`, sin poner registros en cada botón. Al incrementar y
decrementar se ven los valores anterior y siguiente. Sería útil para encontrar
una modificación duplicada o reconstruir qué acciones dejaron una pantalla
con un valor inesperado. El Cubit usa int, que es inmutable, y emite el nuevo
valor: coincide con Cubit<int> pedido en A.4.

## 4. Salida de los tres comandos (A.5). ¿Qué demuestran y qué habría que reescribir al cambiar Riverpod?

Ejecutados desde `parte_a_contador`:

```text
$ git diff version/setstate version/riverpod -- lib/domain lib/data
[sin salida; código de salida 0]
$ git diff version/setstate version/bloc -- lib/domain lib/data
[sin salida; código de salida 0]
$ git diff version/setstate version/bloc --stat -- lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    |  40 ++++++++
 .../presentation/pantallas/pantalla_control.dart   |  91 ++++++------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 104 +++++----------------
 3 files changed, 90 insertions(+), 145 deletions(-)
```

Los primeros dos diffs prueban que las tres presentaciones usan exactamente
el mismo núcleo. El tercero muestra cambios reales de pantallas y estado;
no es un selector entre implementaciones que conviven en la misma rama.
Al reemplazar Riverpod, cambiaría presentation y el cableado de main.dart,
sin reescribir los contratos, los casos de uso ni el repositorio.
Cada rama nace del mismo commit main; ninguna versión nace de otra.

### Tabla comparativa (A.6)

| | setState | Riverpod | Cubit |
| --- | --- | --- | --- |
| ¿Dónde vive el contador? | Campo del State de cada pantalla | Estado del Notifier en el provider | Estado int del ContadorCubit |
| ¿Las pantallas se pasan datos? | Sí: valor inicial y resultado de pop | No: ambas leen el provider | No: ambas leen el Cubit |
| Archivos de presentation/ que tocaste | pantallas/pantalla_visor.dart y pantalla_control.dart | Los dos archivos de pantallas; estado/contador_provider.dart y contador_estado.dart | Los dos archivos de pantallas; estado/contador_cubit.dart |
| ¿Qué pasa con el botón atrás? | Sin resultado puede dejar el visor viejo; la versión final relee como protección | Conserva el estado compartido | Conserva el estado compartido |
| ¿Tuviste que tocar domain/? | No al construir la presentación | No | No |

## 5. ¿Qué elegirías para una pantalla y para ocho pantallas con cinco datos compartidos? ¿Cuándo sí es correcto setState?

Para una pantalla elegiría setState: el estado pertenece a ese widget y se
actualiza directamente sin introducir un contenedor compartido. Para ocho
pantallas con cinco datos compartidos elegiría Riverpod, para que todas lean
las mismas fuentes y no tengan que coordinar copias entre rutas.

setState es correcto cuando el estado es local, breve y pertenece a un widget.
También encaja en interacciones sencillas, como abrir una sección o validar un campo.

## 6. ¿Por qué Future seguía mostrando Wi-Fi? ¿Dato incorrecto o correcto de un momento equivocado?

Consultar ahora obtiene un resultado y termina. La prueba mostró Wi-Fi y una
hora HH:mm:ss; tras emitir Sin conexión desde el repositorio de prueba, la foto
seguía mostrando Wi-Fi. Era un dato correcto del momento consultado, pero viejo
para describir el presente. Sólo otra consulta actualizó la pantalla y su hora.
Cambiar entre pestañas conserva la foto, de modo que no se confunde una consulta
nueva con una actualización automática.

## 7. ¿Qué pasa sin cancel() al entrar y salir cincuenta veces?

Si al salir se destruye la pantalla y su Cubit, omitir cancel permite que las
suscripciones anteriores sigan recibiendo eventos, retengan recursos y puedan
intentar emitir sobre un Cubit cerrado. Repetir ese ciclo puede acumular hasta
cincuenta escuchas; el número depende del ciclo de vida de la pantalla. En esta
app alternar pestañas conserva el Cubit, por lo que no crea otra escucha cada
vez. Al desmontar la app, close espera la cancelación. La prueba verificó una
suscripción aunque se llame iniciar dos veces, y una cancelación al cerrar.
También se comprobó cerrar mientras el Future inicial estaba pendiente: después
no se emite ni se abre una suscripción sobre el Cubit cerrado.

## 8. ¿Por qué Future es una foto y Stream una película? Dos datos para cada uno.

Con la conexión, Future conserva el Wi-Fi de la consulta aunque el origen haya
cambiado. Stream recibe el nuevo estado y la pestaña pasa a Sin conexión sin
pulsar Consultar ahora; al recibir Wi-Fi vuelve a actualizarse. La prueba de UI
usa eventos simulados; todavía no acredita el comportamiento físico del teléfono.

Pediría con Future el resultado de enviar un formulario y un catálogo consultado
una vez. Observaría con Stream los mensajes entrantes de un chat y la ubicación
durante un viaje. El tipo de red no garantiza por sí mismo acceso a Internet.

## Decisión cuando el enunciado y la rúbrica difieren

El enunciado permite los plugins en data y ubica allí connectivity_plus. La
rúbrica recibida exige domain y data sin paquetes externos. Por prioridad de
la rúbrica, data recibe funciones inyectadas; SharedPreferences se conecta en
main y el único import de connectivity_plus está en
`parte_b_conexion/lib/infrastructure/conectividad_dispositivo.dart`.
Por eso la búsqueda de connectivity devuelve un único archivo, pero su ruta
es infrastructure, no data. Ningún Cubit ni pantalla conoce el plugin.

El enunciado permite modificar main.dart entre versiones; la rúbrica concentra
el cambio en presentación. Aquí el núcleo es idéntico y main sólo cambia el
cableado de ProviderScope/BlocProvider y la pantalla inicial, como exige A.2-A.4.
