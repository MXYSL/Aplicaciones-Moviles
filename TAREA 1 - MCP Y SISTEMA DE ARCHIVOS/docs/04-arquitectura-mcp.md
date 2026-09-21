# 4. Arquitectura del Model Context Protocol

## 4.1. Introducción

El Model Context Protocol (MCP) establece una arquitectura de comunicación que permite integrar aplicaciones basadas en modelos de lenguaje con herramientas, recursos y servicios externos. Su finalidad es proporcionar un mecanismo común para que diferentes aplicaciones puedan descubrir y utilizar capacidades sin desarrollar una integración completamente distinta para cada proveedor.

Para comprender su funcionamiento es necesario identificar los componentes que participan en la comunicación y distinguir sus responsabilidades. En particular, MCP utiliza una arquitectura formada por un host, uno o varios clientes MCP y uno o varios servidores MCP.

Esta separación es importante porque el modelo de lenguaje no ejecuta directamente las operaciones sobre el sistema operativo. Las solicitudes se gestionan mediante una aplicación que dispone de componentes de comunicación y servidores capaces de realizar acciones concretas.

En la implementación desarrollada para esta tarea, Visual Studio Code con GitHub Copilot funciona como entorno anfitrión, mientras que el servidor MCP Filesystem proporciona las herramientas necesarias para trabajar con archivos locales.

**Versión de referencia:** especificación MCP `2026-07-28`, publicada el 28 de julio de 2026.

## 4.2. Modelo host, cliente y servidor

### 4.2.1. Host

El host es la aplicación que incorpora la experiencia de interacción con el modelo de lenguaje y administra las conexiones con los servidores MCP.

Entre sus responsabilidades se encuentran presentar la interfaz de usuario, coordinar las solicitudes, gestionar las herramientas disponibles y aplicar las políticas de autorización correspondientes.

Un host puede establecer conexiones con varios servidores MCP. Por ejemplo, un entorno de desarrollo podría conectarse simultáneamente a un servidor de sistema de archivos, otro de control de versiones y otro que permita consultar una base de datos.

En nuestra práctica, el host es Visual Studio Code con GitHub Copilot. Desde su interfaz se escribieron las instrucciones para leer, crear, modificar y buscar archivos.

### 4.2.2. Cliente MCP

El cliente MCP es el componente encargado de mantener la comunicación con un servidor MCP determinado.

Su función consiste en intercambiar mensajes del protocolo, descubrir las capacidades del servidor y enviar las solicitudes de ejecución correspondientes.

Es importante distinguir el cliente MCP de la persona usuaria. La persona formula la solicitud en lenguaje natural, mientras que el cliente es un componente de software que participa en la comunicación estructurada.

En nuestra implementación, Visual Studio Code administra la conexión MCP con el servidor Filesystem. Aunque el usuario interactúa con GitHub Copilot, las operaciones sobre archivos se realizan mediante la conexión establecida con el servidor.

### 4.2.3. Servidor MCP

El servidor MCP es el componente que publica capacidades externas y atiende las solicitudes recibidas mediante el protocolo.

Un servidor puede ofrecer herramientas para ejecutar operaciones, recursos para consultar información y plantillas de prompt que faciliten determinados flujos de trabajo.

El servidor puede comunicarse con APIs, bases de datos, servicios remotos, bibliotecas o recursos del sistema operativo, dependiendo de su finalidad.

En nuestra práctica, el servidor es `@modelcontextprotocol/server-filesystem`. Este programa utiliza Node.js y proporciona operaciones controladas sobre el sistema de archivos local.

## 4.3. Arquitectura utilizada en la práctica

La arquitectura implementada puede representarse de la siguiente manera:

```text
                   PERSONA USUARIA
                          |
                          | Solicitud en lenguaje natural
                          v
              VISUAL STUDIO CODE
                  GitHub Copilot
                       HOST
                          |
                          | Selección de herramienta
                          v
                     CLIENTE MCP
                          |
                          | Mensajes MCP / JSON-RPC 2.0
                          | Transporte stdio
                          v
                 SERVIDOR FILESYSTEM
                          |
                          | Validación de ruta
                          | Operación solicitada
                          v
                  SISTEMA DE ARCHIVOS
                          |
                          v
                  DIRECTORIO PERMITIDO
```

La persona usuaria no necesita escribir manualmente una llamada JSON-RPC para utilizar el servidor. Puede solicitar una operación en lenguaje natural y el asistente selecciona la herramienta correspondiente entre las capacidades disponibles.

El cliente MCP transmite la solicitud y el servidor ejecuta la operación. Posteriormente, el resultado se devuelve al entorno anfitrión para presentarlo en la conversación.

Esta arquitectura permite diferenciar la interpretación de una instrucción, la comunicación mediante MCP y la ejecución real sobre los archivos.

## 4.4. Primitivas que expone un servidor MCP

MCP define tres categorías principales de capacidades del lado del servidor: herramientas, recursos y plantillas de prompt.

Estas categorías tienen finalidades diferentes y no deben utilizarse como sinónimos.

### 4.4.1. Herramientas o tools

Las herramientas representan operaciones que una aplicación puede solicitar al servidor.

Una herramienta se identifica mediante un nombre, una descripción y un esquema de parámetros. Estos elementos permiten que el cliente conozca qué operación realiza y qué información necesita para ejecutarse.

Las herramientas pueden utilizarse para consultar información o realizar acciones que modifiquen el estado de un sistema. Por ello, algunas requieren precauciones adicionales, como una confirmación antes de ejecutarse.

El protocolo contempla el descubrimiento mediante `tools/list` y la ejecución mediante `tools/call`.

En nuestra implementación, `read_text_file`, `write_file`, `edit_file` y `search_files` son ejemplos de herramientas.

### 4.4.2. Recursos o resources

Los recursos permiten que un servidor publique información identificable mediante URI para que una aplicación pueda consultarla.

Su finalidad principal es proporcionar contenido o contexto, no ejecutar necesariamente una modificación sobre el sistema.

Un recurso podría representar un documento, una configuración, un registro o información procedente de un servicio externo.

Entre los métodos relacionados con esta capacidad se encuentran `resources/list` y `resources/read`.

Es importante señalar que un servidor MCP no está obligado a implementar las tres categorías de capacidades. El servidor Filesystem utilizado en esta práctica publica herramientas para realizar sus operaciones; no debe afirmarse que expone recursos o plantillas de prompt únicamente porque MCP contemple esas primitivas.

### 4.4.3. Plantillas de prompt o prompts

Las plantillas de prompt permiten publicar estructuras reutilizables para determinados tipos de interacción.

Una plantilla puede incorporar instrucciones, argumentos y mensajes que faciliten la realización de una tarea específica.

Por ejemplo, un servidor podría publicar una plantilla destinada a revisar código fuente, analizar un documento o preparar una consulta técnica.

Los métodos asociados incluyen `prompts/list`, para descubrir las plantillas disponibles, y `prompts/get`, para obtener una plantilla determinada.

A diferencia de una herramienta, una plantilla no representa necesariamente una acción ejecutable sobre un recurso externo. Su función consiste en estructurar la interacción que se proporciona al modelo.

## 4.5. Primitivas del lado del cliente

Además de las capacidades publicadas por los servidores, MCP contempla mecanismos relacionados con el contexto y la interacción que puede proporcionar el cliente.

### 4.5.1. Roots

Los roots permiten comunicar al servidor información sobre las ubicaciones que el cliente considera relevantes para una sesión de trabajo, como los directorios de un proyecto.

En implementaciones compatibles con el mecanismo tradicional de roots, un servidor puede solicitar las raíces mediante `roots/list`.

Este mecanismo resultó especialmente importante en nuestra práctica. El servidor Filesystem recibió desde Visual Studio Code la raíz del espacio de trabajo y actualizó sus directorios autorizados.

Como consecuencia, la carpeta principal de la tarea apareció como directorio permitido, aunque inicialmente se había indicado `workspace-mcp` como argumento de ejecución.

**Nota de versión:** roots fue declarado obsoleto en la especificación `2026-07-28`, aunque sigue siendo compatible en implementaciones que utilizan el mecanismo anterior. En desarrollos nuevos se recomienda considerar alternativas como parámetros de herramientas, URI de recursos o configuración explícita del servidor.

### 4.5.2. Elicitation

Elicitation permite solicitar información adicional a la persona usuaria cuando una operación necesita datos que todavía no están disponibles.

Por ejemplo, una herramienta podría requerir que el usuario confirme una opción, complete un campo o proporcione información necesaria para continuar.

Este mecanismo permite estructurar solicitudes adicionales durante un flujo de trabajo, en lugar de depender exclusivamente de instrucciones improvisadas.

En la revisión `2026-07-28`, las interacciones que requieren intercambios adicionales se integran en el mecanismo de solicitudes de múltiples intercambios, conocido como *Multi Round-Trip Requests*.

La ventana de autorización que observamos antes de ejecutar `write_file` es una confirmación presentada por el host. No debemos identificarla automáticamente como una llamada de elicitation, porque no capturamos evidencia de que se haya utilizado esa primitiva específica.

## 4.6. Transportes de MCP

El transporte define cómo circulan los mensajes entre el cliente y el servidor MCP.

MCP utiliza mensajes basados en JSON-RPC 2.0, pero puede transmitirlos mediante distintos mecanismos.

Los dos transportes principales que deben distinguirse en esta investigación son `stdio` y Streamable HTTP.

### 4.6.1. Transporte stdio

El transporte `stdio` utiliza la entrada estándar y la salida estándar de un proceso para intercambiar mensajes.

Es especialmente apropiado para servidores locales que son iniciados por la aplicación anfitriona como procesos independientes.

En este esquema, el cliente inicia el servidor y mantiene la comunicación a través de los canales del proceso.

En nuestra implementación, Visual Studio Code ejecutó el servidor Filesystem mediante `cmd`, `npx` y Node.js.

La configuración incluyó:

```json
{
  "type": "stdio",
  "command": "cmd",
  "args": [
    "/c",
    "npx",
    "-y",
    "@modelcontextprotocol/server-filesystem",
    "RUTA_DEL_DIRECTORIO_AUTORIZADO"
  ]
}
```

Este fragmento es ilustrativo. En el repositorio, la configuración efectiva se encuentra en `.vscode/mcp.json`.

Los mensajes del protocolo utilizan los canales de entrada y salida estándar. Los mensajes de diagnóstico del servidor pueden enviarse a la salida de error estándar, conocida como `stderr`.

Durante las pruebas, Visual Studio Code mostró mensajes como:

```text
Secure MCP Filesystem Server running on stdio
Discovered 14 tools
Updated allowed directories from MCP roots: 1 valid directories
```

Estos registros permitieron comprobar que el servidor estaba funcionando y que recibió información de roots desde el cliente.

### 4.6.2. Transporte Streamable HTTP

Streamable HTTP permite comunicar clientes y servidores MCP mediante HTTP.

Es especialmente relevante para servicios remotos y entornos en los que las aplicaciones necesitan acceder a capacidades publicadas en infraestructura externa.

A diferencia de `stdio`, no depende de que el servidor sea iniciado como proceso hijo de la aplicación cliente.

El servidor puede permanecer disponible mediante un endpoint HTTP y atender solicitudes de diferentes clientes, de acuerdo con su implementación y mecanismos de autorización.

El uso de HTTP no convierte automáticamente a MCP en una API REST tradicional. MCP conserva sus métodos, estructuras y reglas de comunicación basadas en JSON-RPC 2.0.

La revisión `2026-07-28` incorporó cambios para facilitar un núcleo de protocolo sin estado y mejorar su funcionamiento sobre infraestructura HTTP.

## 4.7. Consideración sobre las versiones del protocolo

La especificación MCP evoluciona y sus diferentes revisiones pueden modificar mecanismos de comunicación y capacidades.

La revisión `2026-07-28` introdujo un núcleo sin estado, solicitudes de múltiples intercambios y cambios relacionados con el descubrimiento y la autorización.

Por esta razón, no debe suponerse que todas las instalaciones existentes utilizan exactamente los mismos mensajes o mecanismos de inicialización.

Por ejemplo, el servidor Filesystem utilizado durante la práctica mostró un comportamiento basado en roots que continúa siendo compatible, aunque la revisión de referencia declaró obsoleto ese mecanismo.

También debe distinguirse la versión de la especificación de la versión del paquete instalado mediante npm. No son el mismo dato.

En esta investigación se utiliza como referencia documental la especificación `2026-07-28`, mientras que las evidencias describen el comportamiento efectivamente observado en Visual Studio Code.

## 4.8. Conclusión

La arquitectura MCP separa las responsabilidades del host, el cliente y el servidor.

El host administra la experiencia de uso; el cliente mantiene la comunicación; y el servidor publica y ejecuta las capacidades externas.

Las herramientas, los recursos y las plantillas de prompt permiten integrar diferentes tipos de funcionalidades, mientras que los transportes determinan cómo se intercambian los mensajes.

La práctica con GitHub Copilot y Filesystem permitió comprobar que el modelo no necesita ejecutar directamente operaciones del sistema operativo para participar en tareas sobre archivos locales.

La operación se realiza mediante componentes especializados, un protocolo de comunicación y controles de acceso que deben verificarse durante la ejecución.

## Referencias

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/

Model Context Protocol. (s. f.). *Model Context Protocol specification*. https://modelcontextprotocol.io/specification/2026-07-28

Model Context Protocol. (s. f.). *Filesystem MCP Server*. GitHub. https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

Microsoft. (s. f.). *Use MCP servers in VS Code*. https://code.visualstudio.com/docs/copilot/customization/mcp-servers