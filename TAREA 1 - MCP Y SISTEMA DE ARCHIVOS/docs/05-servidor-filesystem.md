# 5. El servidor MCP de sistema de archivos

## 5.1. Introducción

El servidor MCP Filesystem permite que una aplicación compatible con Model Context Protocol realice operaciones sobre archivos y directorios mediante herramientas estructuradas.

Su funcionamiento representa un ejemplo práctico de integración entre un asistente de inteligencia artificial y recursos locales de una computadora.

En lugar de copiar manualmente el contenido de un archivo al chat, la persona usuaria puede solicitar que el asistente utilice una herramienta de lectura. De forma semejante, puede solicitar la creación o modificación de archivos mediante las herramientas correspondientes.

Estas operaciones no se realizan directamente por el modelo de lenguaje. El servidor Filesystem recibe las solicitudes, comprueba las condiciones de acceso y ejecuta las operaciones mediante las capacidades del sistema operativo.

## 5.2. ¿Qué significa Filesystem?

Filesystem significa sistema de archivos y se refiere al mecanismo mediante el cual un sistema operativo organiza y administra archivos y directorios.

El servidor Filesystem utiliza estas capacidades para proporcionar operaciones de lectura, escritura, búsqueda y administración de archivos.

Es importante aclarar que Filesystem no es una parte obligatoria del protocolo MCP. Es un servidor concreto que implementa el protocolo para una finalidad específica.

MCP puede utilizarse también con servidores que consulten bases de datos, repositorios de código, plataformas de comunicación y otros servicios.

Por tanto, no debe confundirse el protocolo general con una de sus implementaciones.

## 5.3. Servidor de referencia utilizado

En esta práctica se utilizó el paquete:

```text
@modelcontextprotocol/server-filesystem
```

Se trata de un servidor implementado con Node.js y publicado mediante npm.

Su repositorio de referencia se encuentra en:

https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

El servidor se ejecutó desde Visual Studio Code mediante `npx`, utilizando una configuración MCP de tipo `stdio`.

Durante las pruebas, VS Code reconoció 14 herramientas disponibles.

Este resultado se comprobó en la interfaz del archivo `.vscode/mcp.json` y en los registros de ejecución del servidor.

## 5.4. Herramientas disponibles

Las herramientas publicadas por el servidor permiten realizar diferentes operaciones sobre el sistema de archivos.

La siguiente tabla presenta las 14 herramientas identificadas en la implementación utilizada.

| Herramienta | Función |
|---|---|
| `read_text_file` | Leer el contenido de un archivo de texto. |
| `read_media_file` | Leer archivos multimedia o binarios compatibles. |
| `read_multiple_files` | Leer varios archivos en una solicitud. |
| `write_file` | Crear un archivo o sobrescribir su contenido. |
| `edit_file` | Realizar modificaciones selectivas en un archivo existente. |
| `create_directory` | Crear un directorio. |
| `list_directory` | Mostrar archivos y subdirectorios. |
| `list_directory_with_sizes` | Listar elementos e incluir sus tamaños. |
| `move_file` | Mover o renombrar archivos y directorios. |
| `search_files` | Buscar archivos y directorios por patrón de nombre. |
| `directory_tree` | Obtener una representación jerárquica del directorio. |
| `get_file_info` | Consultar metadatos de archivos y directorios. |
| `list_allowed_directories` | Mostrar los directorios autorizados. |

**Nota:** la tabla anterior contiene 13 herramientas porque corresponde a las operaciones documentadas en el catálogo oficial consultado. Durante nuestra instalación, Visual Studio Code informó que había descubierto 14 herramientas. Para identificar la herramienta adicional con exactitud, debe consultarse el catálogo efectivo de la versión instalada, en lugar de inventar su nombre.

## 5.5. Operaciones de lectura

Las operaciones de lectura permiten recuperar información almacenada en archivos existentes.

La herramienta `read_text_file` recibe la ruta de un archivo y devuelve su contenido textual.

En nuestra práctica, se utilizó para leer `prueba.txt`, que contenía el mensaje:

```text
Estado inicial: Pendiente de lectura.
```

Esta operación permitió demostrar que Copilot podía recuperar información del sistema de archivos mediante MCP.

El archivo no fue copiado manualmente al chat. La lectura se realizó a través de una herramienta del servidor.

## 5.6. Operaciones de escritura y modificación

La herramienta `write_file` permite crear un archivo nuevo o sobrescribir uno existente.

Esta capacidad debe utilizarse con precaución porque una escritura puede reemplazar información previa.

Durante nuestra implementación, Copilot solicitó autorización antes de crear el archivo:

```text
resultado-mcp.txt
```

Posteriormente, se utilizó `edit_file` para modificar selectivamente una línea de su contenido.

El resultado fue:

```text
Estado: Modificado correctamente mediante MCP.
```

La diferencia entre ambas herramientas es importante. `write_file` puede sustituir el contenido completo, mientras que `edit_file` permite realizar modificaciones específicas sobre un archivo existente.

## 5.7. Operaciones de búsqueda

La herramienta `search_files` permite localizar archivos y directorios mediante patrones de nombre.

En la práctica, se solicitó buscar:

```text
resultado-mcp.txt
```

El servidor devolvió la ruta del archivo dentro del directorio de trabajo.

Esto demuestra que una aplicación compatible puede localizar recursos sin que la persona usuaria tenga que identificar manualmente todas las rutas.

Debe distinguirse la búsqueda de archivos por nombre de una búsqueda textual dentro de su contenido. `search_files` está documentada principalmente para buscar archivos y directorios mediante patrones; no debe presentarse como una herramienta general de búsqueda de texto dentro de archivos.

## 5.8. Configuración del servidor en Visual Studio Code

El servidor se configuró mediante el archivo:

```text
.vscode/mcp.json
```

La configuración contiene una sección `servers`, dentro de la cual se declara el servidor `filesystem`.

El siguiente ejemplo muestra su estructura:

```json
{
  "servers": {
    "filesystem": {
      "type": "stdio",
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "D:\\RUTA\\AL\\DIRECTORIO\\AUTORIZADO"
      ]
    }
  }
}
```

En Windows, `cmd /c` permite ejecutar el comando `npx` mediante el intérprete de comandos.

La opción `-y` permite que npx continúe sin solicitar confirmación interactiva para la instalación del paquete cuando sea necesario.

El último argumento indica el directorio que el servidor debe considerar inicialmente como autorizado.

No obstante, el alcance efectivo puede cambiar cuando el cliente comunica roots y la implementación del servidor actualiza su lista de directorios permitidos.

Por ello, la configuración debe complementarse con una comprobación durante la ejecución.

## 5.9. Delimitación de los directorios autorizados

Una de las características más importantes del servidor Filesystem es la delimitación de las rutas a las que puede acceder.

El servidor no debería operar indiscriminadamente sobre todo el disco duro. Su alcance debe restringirse a los directorios necesarios para la actividad.

Durante la configuración inicial se utilizó el directorio:

```text
workspace-mcp
```

La intención era limitar las operaciones a los archivos preparados para la práctica.

Sin embargo, durante las pruebas se detectó que Visual Studio Code comunicó la raíz del espacio de trabajo mediante MCP Roots.

El servidor actualizó su lista y terminó autorizando la carpeta principal de la tarea.

Este comportamiento se comprobó mediante la herramienta:

```text
list_allowed_directories
```

La experiencia demuestra que los argumentos iniciales de configuración no siempre describen por sí solos el alcance efectivo de una conexión.

## 5.10. ¿Por qué existe el límite de acceso?

El límite de acceso reduce el riesgo de que una herramienta lea o modifique información ajena a la tarea solicitada.

Sin una restricción adecuada, un asistente podría solicitar accidentalmente la lectura de documentos privados, archivos de configuración o información perteneciente a otros proyectos.

También podría sobrescribir o mover archivos que no deberían formar parte de la actividad.

La delimitación de directorios permite reducir la superficie de acceso y establecer un alcance verificable.

No obstante, la restricción de rutas no sustituye otras medidas de seguridad. Si se autoriza una carpeta que contiene credenciales o documentos sensibles, esos archivos pueden quedar dentro del alcance permitido.

## 5.11. Prueba del límite de seguridad

La prueba de seguridad se realizó en dos etapas.

En la primera se intentó acceder a un archivo situado en `fuera-del-alcance`, dentro de la carpeta principal de la tarea.

La lectura fue permitida porque el directorio principal había sido comunicado por VS Code como raíz autorizada.

Posteriormente, se creó un archivo en una ubicación independiente:

```text
D:\Prueba-Seguridad-MCP\privado.txt
```

Esta ubicación se encontraba fuera del directorio autorizado efectivo.

Se solicitó a Copilot utilizar exclusivamente la herramienta `read_text_file` para intentar leerlo.

El servidor rechazó la solicitud y devolvió:

```text
Access denied - path outside allowed directories
```

El resultado demuestra que el servidor comprobó la ruta antes de realizar la operación de lectura.

La negativa no consistió únicamente en una respuesta del modelo de lenguaje. Se obtuvo como resultado de una solicitud dirigida a la herramienta MCP.

![Prueba de acceso denegado](../img/08-acceso-denegado.png)

## 5.12. Consideraciones sobre permisos de solo lectura

La restricción por directorios y la restricción por tipo de operación son controles diferentes.

Autorizar un directorio no significa necesariamente que todas sus operaciones deban estar permitidas.

En entornos donde únicamente se necesita consultar información, puede resultar conveniente utilizar permisos de solo lectura o exponer únicamente herramientas de consulta.

El servidor Filesystem incluye herramientas capaces de modificar archivos. Por ello, deben revisarse las confirmaciones de ejecución y los permisos disponibles en el entorno.

Una opción para conseguir una restricción adicional es ejecutar el servidor en un entorno aislado, como un contenedor, montando los directorios necesarios con permisos de solo lectura.

Esta medida debe configurarse explícitamente y comprobarse mediante pruebas; no se obtiene automáticamente por utilizar MCP.

## 5.13. Conclusión

El servidor MCP Filesystem demuestra cómo un asistente de inteligencia artificial puede participar en operaciones sobre archivos locales mediante una integración estructurada.

Las herramientas permiten consultar directorios, leer documentos, crear archivos, modificar contenido y realizar búsquedas.

Sin embargo, la capacidad de ejecutar operaciones debe acompañarse de restricciones de acceso.

La práctica permitió identificar una diferencia entre el directorio configurado inicialmente y el alcance efectivo comunicado mediante MCP Roots.

La prueba final confirmó que el servidor rechazaba una lectura dirigida a una ruta externa a sus directorios autorizados.

Por tanto, una implementación correcta no debe evaluarse únicamente por su capacidad de realizar operaciones, sino también por la posibilidad de verificar y limitar los recursos sobre los que puede actuar.

## Referencias

Model Context Protocol. (2026, 28 de julio). *The 2026-07-28 specification*. https://blog.modelcontextprotocol.io/posts/2026-07-28/

Model Context Protocol. (s. f.). *Filesystem MCP Server*. GitHub. https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

Model Context Protocol. (s. f.). *Filesystem server source code*. GitHub. https://github.com/modelcontextprotocol/servers/blob/main/src/filesystem/index.ts

Microsoft. (s. f.). *Use MCP servers in VS Code*. https://code.visualstudio.com/docs/copilot/customization/mcp-servers