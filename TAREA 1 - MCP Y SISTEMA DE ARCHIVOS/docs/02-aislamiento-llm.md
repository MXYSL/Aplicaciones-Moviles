# 2. El problema del aislamiento de los modelos de lenguaje

## 2.1. ¿Por qué un LLM no puede acceder directamente a los archivos?

Un modelo de lenguaje procesa información representada mediante tokens y genera una salida a partir del contexto recibido. Por sí mismo, no constituye una aplicación con permisos para abrir archivos, consultar directorios o ejecutar instrucciones del sistema operativo.

Cuando una persona escribe una solicitud como "abre mi archivo de Python", el modelo puede interpretar la intención, pero la interpretación de una instrucción no equivale a su ejecución.

Para abrir un archivo real es necesario que exista un componente de software capaz de interactuar con el sistema operativo. Dicho componente debe identificar la ruta solicitada, comprobar los permisos correspondientes y ejecutar la operación de lectura.

Por esta razón, un LLM aislado puede explicar cómo modificar un programa, pero no puede aplicar directamente los cambios sobre un archivo local si no dispone de una integración que permita realizar esa operación.

## 2.2. Razones arquitectónicas del aislamiento

Una de las razones del aislamiento es la separación entre el entorno donde se ejecuta el modelo y el dispositivo utilizado por la persona.

En numerosos servicios de inteligencia artificial, la inferencia se realiza en infraestructura remota. El equipo del usuario envía una solicitud al servicio y recibe una respuesta mediante una interfaz de comunicación.

El servidor remoto no obtiene automáticamente acceso al disco duro de la computadora desde la cual se envió la solicitud. Para interactuar con archivos locales se requiere un mecanismo de comunicación y un programa que ejecute las operaciones en el entorno correspondiente.

Esta separación es importante porque permite distinguir tres funciones: interpretar una solicitud, decidir qué operación se necesita y ejecutar efectivamente esa operación.

En la implementación de esta práctica, GitHub Copilot participa en la interpretación de la solicitud, mientras que el servidor MCP Filesystem ejecuta las operaciones de archivos dentro del alcance que tiene configurado.

## 2.3. Razones de seguridad

El aislamiento también responde a consideraciones de seguridad. Permitir que cualquier instrucción escrita en una conversación produzca operaciones irrestrictas sobre una computadora introduciría riesgos de lectura, modificación y eliminación de información.

Un asistente podría recibir una solicitud ambigua, interpretar incorrectamente una ruta o proponer una modificación que afecte archivos importantes.

También existe el riesgo de inyección de instrucciones. Un archivo aparentemente informativo puede contener texto que intente convencer al asistente de ignorar las indicaciones del usuario o ejecutar acciones no solicitadas.

Por ello, la integración con herramientas debe considerar mecanismos de consentimiento, restricciones de acceso y validación de las operaciones solicitadas.

La capacidad de utilizar herramientas no debe confundirse con una autorización ilimitada. Cada herramienta puede tener un alcance específico y estar sujeta a confirmaciones antes de ejecutarse.

## 2.4. ¿Qué cambia cuando se incorpora MCP?

MCP permite establecer una comunicación estructurada entre una aplicación que utiliza modelos de lenguaje y un servidor que publica capacidades externas.

El servidor puede anunciar herramientas con nombres, descripciones y esquemas de parámetros. La aplicación cliente obtiene ese catálogo y puede poner las herramientas a disposición del modelo.

Cuando el usuario solicita una operación, el asistente puede seleccionar una herramienta apropiada y proporcionar los argumentos necesarios. El servidor recibe la solicitud y realiza la operación si cumple las condiciones establecidas.

En el caso del servidor Filesystem, las operaciones disponibles incluyen la lectura, escritura, edición y búsqueda de archivos.

La incorporación de MCP no elimina la necesidad de controlar los permisos. Al contrario, hace necesario definir qué herramientas se exponen, qué directorios pueden utilizarse y qué operaciones requieren intervención humana.

## 2.5. Comprobación práctica del aislamiento

Durante la implementación se configuró el servidor MCP Filesystem en Visual Studio Code y se verificó que GitHub Copilot podía ejecutar herramientas sobre archivos locales.

Primero se comprobó que el servidor estaba funcionando y que VS Code había descubierto 14 herramientas.

Después se utilizaron herramientas específicas para listar el directorio, leer un archivo, crear un documento, modificar su contenido y buscarlo por nombre.

Finalmente, se realizó una prueba de seguridad solicitando la lectura de un archivo situado fuera de los directorios autorizados.

El servidor rechazó la operación mediante el siguiente mensaje:

```text
Access denied - path outside allowed directories
```

Este resultado permite distinguir la interpretación de una instrucción por parte del asistente de la ejecución autorizada de una operación por parte del servidor.

El modelo pudo formular la solicitud, pero el servidor aplicó su validación de rutas e impidió acceder al archivo externo.

## 2.6. Observación sobre el alcance efectivo y MCP Roots

Durante las pruebas se detectó que Visual Studio Code comunicaba la raíz del espacio de trabajo al servidor Filesystem mediante MCP Roots.

El servidor actualizó sus directorios autorizados y permitió acceder a un archivo que se encontraba dentro de la carpeta principal de la tarea, aunque fuera de la subcarpeta inicialmente indicada en la configuración.

Por esta razón, se creó un segundo archivo de prueba en una ubicación independiente, fuera del repositorio.

La lectura de ese archivo fue rechazada correctamente.

Esta experiencia demuestra que no basta con revisar el archivo de configuración inicial. También es necesario consultar los directorios autorizados durante la ejecución y comprobar que el alcance efectivo corresponde a lo esperado.

## Referencias

Model Context Protocol. (2026). *Filesystem MCP Server*. GitHub. https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/