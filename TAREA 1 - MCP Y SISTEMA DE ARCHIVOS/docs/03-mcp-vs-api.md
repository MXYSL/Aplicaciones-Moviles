# 3. Model Context Protocol frente a una API tradicional

## 3.1. Introducción

La integración entre aplicaciones es un elemento fundamental de la ingeniería de software. Los sistemas modernos necesitan intercambiar información, ejecutar operaciones y utilizar servicios desarrollados por otros componentes.

Tradicionalmente, estas interacciones se implementan mediante interfaces de programación de aplicaciones, conocidas como API. A través de ellas, un programa puede solicitar información o ejecutar operaciones proporcionadas por otro sistema.

Con la incorporación de modelos de lenguaje a los entornos de desarrollo surgió una necesidad adicional: permitir que un asistente descubra las capacidades disponibles y seleccione las operaciones necesarias para atender una solicitud expresada en lenguaje natural.

El Model Context Protocol (MCP) responde a esta necesidad mediante un protocolo abierto de comunicación entre aplicaciones que utilizan modelos de lenguaje y servidores que publican herramientas, recursos y plantillas de prompt.

MCP no sustituye las APIs. Proporciona una capa de integración que permite presentar capacidades existentes de una manera estandarizada y descubrible para aplicaciones que utilizan inteligencia artificial.

## 3.2. ¿Qué es una API?

Una API, Application Programming Interface, es un contrato que define cómo pueden comunicarse dos componentes de software.

Este contrato establece las operaciones disponibles, los parámetros que deben proporcionarse, la estructura de las respuestas y las condiciones necesarias para utilizar el servicio.

Una API no necesariamente utiliza HTTP. También existen APIs de bibliotecas, sistemas operativos y mecanismos de comunicación entre procesos. Sin embargo, las APIs web son especialmente comunes en aplicaciones distribuidas.

En una API REST, las operaciones suelen organizarse alrededor de recursos identificados mediante URL y se utilizan métodos HTTP como GET, POST, PUT, PATCH y DELETE.

Por ejemplo, un sistema de gestión de tareas puede ofrecer los siguientes endpoints:

| Método | Endpoint | Operación |
|---|---|---|
| GET | `/tasks` | Consultar tareas |
| POST | `/tasks` | Crear una tarea |
| PUT | `/tasks/1` | Actualizar una tarea |
| DELETE | `/tasks/1` | Eliminar una tarea |

Este esquema corresponde al tipo de API Flask implementada en la Práctica 2 de Aplicaciones Móviles.

### ¿Quién decide qué operación se ejecuta?

En una integración tradicional, la persona desarrolladora consulta la documentación de la API y escribe el código encargado de realizar cada solicitud.

Por ejemplo, cuando el usuario presiona el botón para crear una tarea en Android, la aplicación ejecuta una operación previamente programada.

El programa ya conoce qué endpoint utilizar, qué datos enviar y cómo interpretar la respuesta.

La decisión de llamar a ese endpoint está definida en el código de la aplicación.

Esto no significa que las APIs sean incapaces de ofrecer descubrimiento dinámico. Existen mecanismos como OpenAPI y sistemas de hipermedia. La diferencia es que una API convencional no establece por sí misma el mecanismo de selección de herramientas orientado a un asistente de inteligencia artificial que caracteriza a MCP.

## 3.3. ¿Qué es MCP?

El Model Context Protocol es un protocolo abierto que estandariza la comunicación entre aplicaciones que utilizan modelos de lenguaje y sistemas externos.

Su propósito es facilitar que una aplicación compatible descubra y utilice capacidades proporcionadas por servidores MCP.

El protocolo utiliza mensajes estructurados basados en JSON-RPC 2.0.

Un servidor MCP puede publicar herramientas, recursos y plantillas de prompt. Cada una de estas capacidades cumple una función diferente dentro de la integración.

En el caso de las herramientas, el servidor proporciona un catálogo con información que permite identificar las operaciones disponibles.

Una definición de herramienta puede incluir:

- Nombre de la herramienta.
- Descripción de su finalidad.
- Esquema de los parámetros de entrada.
- Información adicional sobre su comportamiento.

El cliente obtiene esta información y puede poner las herramientas a disposición del modelo.

Cuando una persona expresa una solicitud, el asistente puede seleccionar una herramienta adecuada y proporcionar los argumentos correspondientes.

El servidor recibe la solicitud y ejecuta la operación dentro de sus restricciones.

## 3.4. Descubrimiento dinámico de herramientas

Una diferencia importante entre una integración convencional con una API y una integración mediante MCP es la manera en que se presentan las capacidades disponibles.

En una API tradicional, la persona desarrolladora conoce el contrato y programa las solicitudes necesarias.

En MCP, el servidor puede anunciar las herramientas disponibles mediante el método `tools/list`.

La aplicación cliente obtiene el catálogo y lo incorpora al contexto de herramientas que puede utilizar el asistente.

Cuando se necesita ejecutar una operación, el cliente puede utilizar `tools/call`, proporcionando el nombre de la herramienta y sus argumentos.

Esto permite que diferentes servidores publiquen capacidades bajo una interfaz común.

Durante nuestra implementación, Visual Studio Code reconoció 14 herramientas del servidor MCP Filesystem.

Entre ellas se utilizaron:

| Herramienta | Operación realizada |
|---|---|
| `list_allowed_directories` | Consultar los directorios autorizados |
| `list_directory` | Listar archivos |
| `read_text_file` | Leer un archivo |
| `write_file` | Crear un archivo |
| `edit_file` | Modificar contenido |
| `search_files` | Buscar un archivo |

La selección de herramientas ocurrió dentro de GitHub Copilot, mientras que la ejecución de las operaciones correspondió al servidor MCP Filesystem.

## 3.5. Tabla comparativa: MCP frente a una API

| Criterio | API tradicional | MCP |
|---|---|---|
| Propósito principal | Establecer un contrato de comunicación entre componentes de software. | Estandarizar la exposición y utilización de capacidades externas por aplicaciones que emplean modelos de lenguaje. |
| Quién decide qué se invoca | Generalmente, el código de la aplicación determina la operación según su lógica programada. | El asistente puede seleccionar una herramienta según la solicitud del usuario, entre las que el cliente tenga disponibles y habilitadas. |
| Descubrimiento de capacidades | Mediante documentación, especificaciones como OpenAPI u otros mecanismos propios del servicio. | Mediante métodos estandarizados de descubrimiento, como `tools/list`. |
| Acoplamiento | El cliente suele implementar directamente el contrato particular del servicio. | El cliente puede utilizar una interfaz MCP común para comunicarse con servidores diferentes. |
| Formato de mensajes | Depende de la API: JSON, XML, HTTP, gRPC u otros formatos y mecanismos. | Mensajes basados en JSON-RPC 2.0, transportados mediante mecanismos admitidos por MCP. |
| Autenticación | Depende del servicio: API keys, sesiones, OAuth, JWT u otros mecanismos. | Depende del transporte y del servidor. MCP contempla mecanismos de autorización, especialmente para servidores HTTP. |
| Consentimiento del usuario | Se implementa según las necesidades y el diseño de la aplicación. | El host puede presentar confirmaciones antes de ejecutar herramientas; no todas las operaciones requieren necesariamente la misma aprobación. |
| Reutilización | Una API puede ser utilizada por diferentes aplicaciones que implementen su contrato. | Un servidor MCP puede ser utilizado por distintos clientes compatibles que admitan sus capacidades y transporte. |
| Relación con el modelo de lenguaje | La API no requiere un modelo de lenguaje para funcionar. | MCP está diseñado para integrar capacidades externas con aplicaciones que utilizan modelos de lenguaje. |
| Ejemplo de uso | Android consume los endpoints REST de Flask. | GitHub Copilot utiliza las herramientas del servidor MCP Filesystem. |

## 3.6. Ejemplo de comunicación con una API REST

En la Práctica 2 se implementó una aplicación Android conectada a un backend Flask.

Para consultar las tareas, el cliente puede enviar una petición HTTP semejante a la siguiente:

```http
GET /tasks HTTP/1.1
Host: localhost:5000
Authorization: Bearer TOKEN_DE_EJEMPLO
```

El backend interpreta la solicitud y devuelve una respuesta JSON.

Por ejemplo:

```json
{
  "tasks": [
    {
      "id": 1,
      "titulo": "Investigar MCP",
      "descripcion": "Comparar MCP con una API",
      "completada": false
    }
  ]
}
```

La aplicación Android conoce previamente el endpoint `/tasks`.

La persona desarrolladora implementó el código encargado de solicitar la información, interpretar la respuesta y presentarla en la interfaz.

## 3.7. Ejemplo de comunicación mediante MCP

En MCP, el cliente puede solicitar primero el catálogo de herramientas del servidor.

Un ejemplo simplificado de mensaje JSON-RPC 2.0 es:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/list",
  "params": {}
}
```

El servidor puede responder con un catálogo que incluya herramientas y sus esquemas.

Por ejemplo:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "tools": [
      {
        "name": "read_text_file",
        "description": "Lee el contenido de un archivo de texto.",
        "inputSchema": {
          "type": "object",
          "properties": {
            "path": {
              "type": "string"
            }
          },
          "required": ["path"]
        }
      }
    ]
  }
}
```

Este ejemplo es ilustrativo y está simplificado; no representa una captura literal del tráfico de nuestra instalación.

Posteriormente, el cliente puede solicitar la ejecución de una herramienta:

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "read_text_file",
    "arguments": {
      "path": "D:\\MCP\\workspace-mcp\\prueba.txt"
    }
  }
}
```

En nuestra práctica, la herramienta utilizada fue `read_text_file`, proporcionada por el servidor MCP Filesystem.

La operación permitió leer un archivo local sin copiar manualmente su contenido al chat.

**Nota sobre la versión:** estos ejemplos muestran la estructura básica de los métodos JSON-RPC. La especificación MCP 2026-07-28 incorpora metadatos adicionales para las solicitudes y requisitos específicos para el transporte Streamable HTTP. No deben interpretarse como mensajes completos de esa revisión.

## 3.8. MCP no sustituye las APIs

Es incorrecto afirmar que MCP vuelve obsoletas las APIs.

Las APIs continúan siendo mecanismos fundamentales para la comunicación entre aplicaciones y servicios.

MCP puede utilizar una API existente como mecanismo interno para ejecutar las operaciones que publica.

Por ejemplo, una empresa puede disponer de una API REST para consultar pedidos. Un servidor MCP puede conectarse a esa API y publicar una herramienta llamada `consultar_pedido`.

Cuando el usuario pregunta por el estado de un pedido, el asistente selecciona la herramienta MCP.

El servidor recibe los parámetros, consulta la API REST y devuelve el resultado.

La arquitectura sería:

```text
USUARIO
   |
   v
ASISTENTE DE IA
   |
   v
CLIENTE MCP
   |
   | tools/call
   v
SERVIDOR MCP
   |
   | Solicitud HTTP
   v
API REST
   |
   v
BASE DE DATOS
```

En este escenario, MCP no reemplaza la API REST.

La API continúa realizando su función original y MCP proporciona una interfaz estandarizada para que una aplicación que utiliza modelos de lenguaje pueda descubrir y utilizar esa capacidad.

En nuestra práctica con Filesystem, el servidor no necesitó consumir una API REST externa: utilizó las capacidades del sistema de archivos disponibles en el entorno donde se ejecutaba.

Por tanto, MCP puede envolver APIs, bibliotecas y otros recursos existentes.

## 3.9. Relación con la implementación realizada

La comparación puede comprenderse a partir de dos prácticas desarrolladas en la asignatura.

En la Práctica 2, Android utiliza Retrofit para comunicarse con Flask mediante endpoints REST previamente definidos.

En la Tarea 1, GitHub Copilot utiliza un servidor MCP para descubrir herramientas y realizar operaciones sobre archivos locales.

La diferencia no consiste simplemente en que una tecnología utilice HTTP y la otra no.

MCP también puede utilizar HTTP como transporte.

La diferencia fundamental está en el contrato de integración y en la manera en que las capacidades se descubren, describen y ponen a disposición de una aplicación que utiliza modelos de lenguaje.

En la implementación se comprobó que Copilot podía utilizar herramientas del servidor Filesystem para crear y modificar archivos.

También se verificó que el servidor podía rechazar una solicitud dirigida a un archivo situado fuera de sus directorios autorizados.

Esto demuestra que la selección de una herramienta y la autorización para ejecutarla son responsabilidades distintas.

## 3.10. Conclusión

Las APIs y MCP resuelven necesidades relacionadas, pero no idénticas.

Una API establece las operaciones que un componente de software puede solicitar a otro.

MCP estandariza la manera en que una aplicación que utiliza modelos de lenguaje descubre y utiliza capacidades proporcionadas por servidores externos.

En una integración tradicional, la lógica de la aplicación suele determinar qué operación se ejecuta. En una integración mediante MCP, el asistente puede seleccionar una herramienta según la solicitud del usuario, dentro del catálogo habilitado por el cliente.

La implementación con GitHub Copilot y Filesystem permitió observar esta diferencia en un entorno real de desarrollo.

La principal aportación de MCP no es reemplazar los servicios existentes, sino facilitar su integración con asistentes capaces de participar en tareas de desarrollo mediante herramientas controladas.

## Referencias

Fielding, R. T. (2000). *Architectural styles and the design of network-based software architectures* [Tesis doctoral, University of California, Irvine]. https://ics.uci.edu/~fielding/pubs/dissertation/top.htm

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/

Model Context Protocol. (s. f.). *Tools*. https://modelcontextprotocol.io/specification/2026-07-28/server/tools

Microsoft. (s. f.). *Tools in Visual Studio Code*. https://code.visualstudio.com/docs/copilot/concepts/tools

OpenAPI Initiative. (s. f.). *OpenAPI Specification*. https://spec.openapis.org/oas/latest.html