# Contraste de enunciado y rúbrica - 20 de octubre de 2026

Se revisó el archivo Deber1.md suministrado después de la primera corrección.
Esta revisión reemplaza la comprobación anterior basada sólo en la rúbrica.

| Requisito | Resultado de la revisión |
| --- | --- |
| Carpetas de entrega | parte_a_contador y parte_b_conexion hermanas; RESPUESTAS.md en raíz |
| Tres versiones | Ramas version/setstate, version/riverpod, version/bloc independientes desde main |
| Mismo núcleo | Dos diffs vacíos de domain/data; cambios reales en presentation |
| setState | Constructor y resultado de pop; relectura adicional al volver sin resultado |
| Riverpod | Providers globales fuera del árbol; repositorio/casos inyectados en main; cargar/incrementar/decrementar |
| Cubit | Cubit<int>, valor inmutable inicial 0, casos de uso y observer en main |
| Navegación compartida | Riverpod/Cubit no transportan el contador entre pantallas |
| Parte B | Contrato Future/Stream, dos pestañas, hora, contador y cancelación con await |
| iniciar de B | Consulta inicial y después suscripción; no se duplica ni abre después de cerrar |
| Preguntas y tablas | Ocho preguntas completas, tres comandos de A.5 y cinco filas exactas de A.6 |
| Video | Fuera de esta revisión; lo realizará el estudiante |

## Diferencia que requiere priorizar un documento

La rúbrica exige data sin paquetes externos; el enunciado permite plugins en
data y espera que connectivity aparezca en el repositorio de esa capa.
Se priorizó la rúbrica: data recibe operaciones inyectadas y el plugin está
en infrastructure. La búsqueda en lib devuelve sólo ese archivo. Por tanto,
no se afirma que coincida con la ruta literal indicada por el enunciado.

## Mejoras que cambian el experimento mínimo

setState vuelve a consultar al regresar sin resultado. Esto evita el fallo
del visor desactualizado que el enunciado quiere analizar. La respuesta 1
explica el fallo original, los tres puntos de coordinación y la protección.

El contador de Stream incluye la primera transición desde otro si cambia el
estado, además de los cambios posteriores; esto se documenta expresamente.

## Cambios respecto a la primera corrección

Se reemplazaron las ramas que sólo cambiaban un selector por presentaciones
separadas desde una base común, se ordenaron las carpetas, se usó Cubit<int>,
se añadieron cargar y el provider del repositorio en Riverpod, y se completaron
las preguntas y evidencias con el enunciado real.

Las modificaciones se aplicaron en el repositorio local original
C:\dev\deber1-estado-streams. La carpeta antigua deber1_estado_streams pasó
a llamarse parte_a_contador y Parte B se movió a la raíz. El ZIP es una copia
del resultado. El historial anterior queda bajo respaldo/. 
