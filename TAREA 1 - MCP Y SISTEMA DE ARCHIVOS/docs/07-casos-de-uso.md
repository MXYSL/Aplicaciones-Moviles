# 7. Casos de uso del Model Context Protocol

## 7.1. Introducción

El Model Context Protocol permite conectar aplicaciones que utilizan modelos de lenguaje con herramientas y fuentes de información externas.

Su utilidad puede observarse especialmente en el desarrollo de software, donde una actividad suele involucrar archivos locales, repositorios, documentación, servicios web y sistemas de control de versiones.

Antes de disponer de estas integraciones, una persona debía copiar manualmente fragmentos de código al asistente y trasladar las respuestas al proyecto.

Actualmente, diferentes entornos de desarrollo permiten que los asistentes utilicen herramientas para consultar archivos, analizar estructuras de proyectos y realizar operaciones autorizadas.

MCP facilita estas integraciones mediante un mecanismo común para descubrir y utilizar capacidades proporcionadas por servidores externos.

## 7.2. Visual Studio Code con GitHub Copilot

Visual Studio Code es un entorno de desarrollo que permite trabajar con diferentes lenguajes de programación y administrar proyectos de software.

GitHub Copilot incorpora funciones de asistencia mediante inteligencia artificial dentro del editor.

La integración con MCP permite conectar el entorno con servidores que publican herramientas y otras capacidades.

Estos servidores pueden proporcionar acceso a sistemas de archivos, bases de datos, documentación, navegadores y servicios externos.

En nuestra implementación se utilizó Visual Studio Code 1.138.0 con GitHub Copilot y el servidor MCP Filesystem.

La configuración se realizó mediante el archivo:

```text
.vscode/mcp.json
```

El servidor se ejecutó mediante Node.js y el transporte `stdio`.

Visual Studio Code reconoció 14 herramientas y permitió utilizarlas desde el chat de Copilot.

Las operaciones realizadas incluyeron listar, leer, crear, modificar y buscar archivos.

También se comprobó el rechazo de una lectura dirigida a una ruta externa a los directorios autorizados.

Esta experiencia demuestra que una aplicación de desarrollo puede integrar herramientas MCP para realizar operaciones sobre archivos locales sin que la persona tenga que copiar manualmente su contenido al chat.

## 7.3. Claude Code

Claude Code es una herramienta de asistencia para tareas de programación desarrollada por Anthropic.

Puede utilizarse para trabajar sobre proyectos de software, consultar archivos, realizar modificaciones y participar en flujos de desarrollo.

Su compatibilidad con MCP permite conectar servidores que proporcionan capacidades adicionales.

Por ejemplo, una integración puede permitir consultar documentación externa, utilizar servicios de desarrollo o acceder a recursos que no forman parte del contexto inicial de la conversación.

MCP permite presentar estas capacidades mediante herramientas que el asistente puede descubrir y utilizar según las necesidades de la tarea.

Es importante distinguir Claude Code de Claude como familia de modelos o servicio conversacional. Claude Code es la herramienta concreta utilizada para tareas de desarrollo.

La integración con MCP amplía las fuentes de información y las operaciones disponibles, pero no elimina la necesidad de revisar los permisos concedidos a los servidores.

## 7.4. Cursor

Cursor es un entorno de desarrollo que incorpora funciones de inteligencia artificial para asistir en tareas de programación.

Su documentación describe la compatibilidad con MCP como un mecanismo para conectar herramientas externas y fuentes de información.

Cursor permite configurar servidores MCP mediante archivos de configuración y utilizar sus capacidades desde el agente.

Entre sus casos de uso se encuentran la consulta de documentación, la integración con herramientas de gestión de proyectos y la utilización de servicios externos.

Por ejemplo, un servidor MCP puede proporcionar información procedente de una plataforma de seguimiento de tareas o de una API empresarial.

El asistente puede utilizar esa información como contexto para trabajar sobre un proyecto.

Cursor también contempla mecanismos de aprobación antes de ejecutar herramientas MCP.

Esto permite distinguir la disponibilidad de una herramienta de la autorización necesaria para utilizarla.

## 7.5. Zed

Zed es un editor de código que incorpora funciones de asistencia mediante inteligencia artificial.

Su documentación incluye compatibilidad con servidores MCP locales y remotos.

Los servidores pueden configurarse directamente o instalarse mediante extensiones disponibles para el editor.

Zed permite utilizar herramientas MCP desde su panel de agente.

Entre los ejemplos de integración documentados se encuentran servidores relacionados con GitHub, documentación, automatización de navegadores y servicios de desarrollo.

Una característica relevante es que Zed permite administrar permisos de ejecución para las herramientas del agente.

También puede recibir notificaciones cuando cambia el catálogo de herramientas de un servidor compatible.

Esto permite actualizar las capacidades disponibles durante el funcionamiento de la aplicación.

## 7.6. Comparación de herramientas

| Herramienta | Tipo de aplicación | Uso de MCP | Ejemplo de aplicación |
|---|---|---|---|
| Visual Studio Code + GitHub Copilot | Entorno de desarrollo con asistente de IA | Conectar servidores que publican herramientas y recursos externos. | Leer y modificar archivos mediante Filesystem. |
| Claude Code | Herramienta de asistencia para programación | Ampliar las capacidades del asistente mediante servidores externos. | Consultar documentación o servicios relacionados con el proyecto. |
| Cursor | Entorno de desarrollo con funciones de IA | Integrar herramientas y fuentes de información mediante MCP. | Consultar documentación y plataformas de gestión de proyectos. |
| Zed | Editor de código con funciones de IA | Conectar servidores MCP locales o remotos. | Utilizar herramientas externas desde el panel de agente. |

Las cuatro herramientas permiten ampliar las capacidades disponibles para el asistente, pero no debe suponerse que todas implementan exactamente las mismas primitivas, transportes o políticas de autorización.

Cada aplicación debe evaluarse de acuerdo con su documentación y la versión instalada.

## 7.7. ¿Cómo pueden trabajar con repositorios completos?

Un repositorio de software contiene archivos de código fuente, documentación, configuraciones y otros recursos organizados en directorios.

Cuando un asistente dispone de herramientas apropiadas, puede consultar la estructura del proyecto y recuperar archivos relevantes para una tarea.

Posteriormente, puede proponer o realizar modificaciones mediante las herramientas habilitadas.

Por ejemplo, ante una solicitud para modificar una aplicación, el asistente podría consultar la estructura del repositorio, identificar archivos relacionados, leer su contenido y modificar los componentes necesarios.

Esta secuencia puede realizarse sin copiar manualmente cada archivo al chat.

Sin embargo, es importante aclarar que MCP no es la única tecnología que permite trabajar sobre repositorios.

Los entornos de desarrollo también pueden disponer de herramientas integradas para consultar y editar archivos.

La aportación específica de MCP consiste en estandarizar la conexión con capacidades publicadas por servidores externos.

## 7.8. Ejemplo aplicado a nuestra práctica

Durante la implementación se utilizó GitHub Copilot para trabajar sobre el directorio `workspace-mcp`.

La secuencia de operaciones fue:

```text
Solicitud de la persona usuaria
            |
            v
GitHub Copilot interpreta la tarea
            |
            v
Selecciona una herramienta MCP
            |
            v
El servidor Filesystem valida la ruta
            |
            v
Ejecuta la operación autorizada
            |
            v
Devuelve el resultado al chat
```

La creación de `resultado-mcp.txt` demostró que el asistente podía solicitar una operación de escritura.

La modificación posterior confirmó que también podía realizar cambios selectivos sobre un archivo existente.

La búsqueda permitió localizar el documento mediante su nombre.

Finalmente, la prueba de acceso externo mostró que el servidor podía rechazar una operación cuando la ruta no pertenecía a sus directorios autorizados.

## 7.9. Ventajas y limitaciones

La integración de herramientas mediante MCP permite reducir operaciones manuales, reutilizar servidores entre aplicaciones compatibles y ampliar el contexto disponible para los asistentes.

También facilita la separación entre la aplicación que utiliza el modelo y el componente encargado de ejecutar las operaciones.

No obstante, estas capacidades presentan limitaciones.

La compatibilidad depende de las funciones implementadas por cada cliente y servidor.

También pueden existir diferencias entre versiones del protocolo y mecanismos de autorización.

Además, el acceso a herramientas no garantiza que el asistente interprete correctamente todas las solicitudes.

Por ello, las operaciones deben revisarse y probarse, especialmente cuando afectan archivos importantes o sistemas externos.

## 7.10. Conclusión

MCP representa un mecanismo de integración que permite ampliar las capacidades de las aplicaciones que utilizan modelos de lenguaje.

Visual Studio Code, Claude Code, Cursor y Zed son ejemplos de herramientas que incorporan compatibilidad con este protocolo.

Su utilización permite conectar asistentes con recursos externos y participar en flujos de desarrollo más amplios.

La práctica realizada con GitHub Copilot y Filesystem permitió comprobar estas capacidades mediante operaciones reales sobre archivos locales.

El resultado principal es que el asistente puede intervenir en tareas de desarrollo sin requerir que la persona copie manualmente todos los archivos, siempre que existan herramientas adecuadas y permisos para utilizarlas.

## Referencias

Anthropic. (s. f.). *Connect Claude Code to tools via MCP*. Claude Code Docs. https://code.claude.com/docs/en/mcp

Cursor. (s. f.). *Model Context Protocol*. https://docs.cursor.com/context/model-context-protocol

Microsoft. (s. f.). *Add and manage MCP servers in VS Code*. Visual Studio Code. https://code.visualstudio.com/docs/agent-customization/mcp-servers

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/

Zed Industries. (s. f.). *Model Context Protocol*. Zed Documentation. https://zed.dev/docs/ai/mcp