1. El contador se guardó correctamente en el almacenamiento local, pero la pantalla no se actualizó al regresar porque el widget no volvió a leer el valor. Quedó desactualizado el estado de la UI (la pantalla), mientras que la persistencia en disco sí contenía el valor correcto.
Tuvieron que ponerse de acuerdo 3 lugares:
El origen que modifica el dato.
La memoria
El widget que recibe la variable

2. El boton de atras ya no esta acoplado al Statefulwidget, el widget vive en la capa de estado dependiendo la rama Notifier o Cubit.

3. Este permite ver todas los cambios de estado del bloc o cubit sin necesitar un print por ejemplo.Puede ser bastante util cuando estas probando que funciona bien el codigo bastante rápido y sin tanto esfuerzo.

4. Que los dos primeros esten vacios demuestra el uso de arquitectura limpia, además de que ni la capa de Domain ni la de Data importan paquetes de presentación. El tercero no sale vacío porque la capa de Presentation es la única encargada de organizar la interfaz de usuario.
Si se cambia Riverpod, solo se tendria que modificar la capa de presentation, la logica ya no.

5. La mejor opcion puede ser la de setState, es rápida y no necesita instalar paquetes ni complicar la estructura para usarla. Si tuviera 8 pantallas y 5 datos compartidos, podria usar riverpod, con este todos los datos se pueden manejar en un solo lugar y cualquier pantalla puede leerlos o cambiarlos sin problemas.

6. Porque el Future solo toma la informacion especifica en el momento que entra a la pantalla. Si se apaga el Wi-Fi después, la pantalla no tiene forma de enterarse sola porque nadie le avisó del cambio. La app tenía un dato correcto de un momento equivocado. El estado cambió después y la pantalla se quedó por asi decirlo en el pasado.

7. Si el usuario entra y sale 50 veces de esa pantalla, la aplicación creará como bastantes tareas "invisibles" en segundo plano que nunca se cierran. Esto provocará que la app consuma memoria innecesaria, se vuelva lenta, descargue la batería del teléfono innecesariamente, etc. 

8. Un Future de dice que es como una foto porque te da la respuesta una sola vez y se termina, como solo capturar un momento especifico, no importa que pase después de esto.

Un Stream es como una película porque se queda como abierto cambiando y "actuando" en vivo todo lo que pasa

2 datos con Future:
Cuando se revisa el usuario y contraseña en una app solo lo hace al entrar.
Carcarg un catalogo de compras


2 datos con Stream:
Rastrear la ubicación en tiempo real en un mapa (como Uber o Google Maps).
Recibir mensajes en vivo en un chat de WhatsApp.