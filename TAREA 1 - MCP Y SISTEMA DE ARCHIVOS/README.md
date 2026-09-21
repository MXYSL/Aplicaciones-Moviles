# Tarea 1. MCP y sistema de archivos: investigación e implementación

## Objetivo

Investigar el Model Context Protocol (MCP), compararlo con las APIs tradicionales e implementar un servidor MCP de sistema de archivos conectado a GitHub Copilot en Visual Studio Code.

## Entorno de implementación

|Herramienta|Versión|
|-|-|
|Sistema operativo|Windows 11|
|Visual Studio Code|1.138.0|
|Node.js|24.21.0|
|npm|11.19.0|
|Git|2.55.0.windows.5|
|Cliente de IA|GitHub Copilot|

## Estado del proyecto

* \[x] Crear estructura de directorios.
* \[x] Preparar archivos de prueba.
* \[x] Configurar el servidor MCP Filesystem.
* \[x] Iniciar el servidor en VS Code.
* \[x] Verificar que VS Code reconoce 14 herramientas.
* \[x] Comprobar los directorios autorizados.
* \[ ] Realizar las operaciones sobre archivos.
* \[ ] Documentar la investigación.
* \[ ] Ejecutar la prueba del límite de seguridad.

## Directorio autorizado

El servidor Filesystem se configuró para operar sobre el directorio workspace-mcp.

El archivo
uera-del-alcance/privado.txt se utilizará exclusivamente para comprobar las restricciones de acceso.



\## Primeras pruebas de funcionamiento



\### Reconocimiento del servidor



Se configuró el servidor MCP Filesystem en Visual Studio Code mediante el archivo `.vscode/mcp.json`, utilizando el transporte `stdio`.



El servidor inició correctamente y VS Code reconoció las 14 herramientas publicadas.



!\[Servidor MCP reconocido](img/01-servidor-reconocido.png)



\### Verificación del directorio autorizado



Mediante la herramienta `list\_allowed\_directories`, se comprobó que el servidor tiene autorizado únicamente el directorio `workspace-mcp`.



!\[Directorio autorizado](img/02-directorio-autorizado.png)



\### Listado de archivos



Se utilizó la herramienta `list\_directory` para consultar el contenido del directorio autorizado.



El servidor identificó los archivos `actividades.txt` y `prueba.txt`.



!\[Listado de archivos](img/03-listar-directorio.png)



\### Lectura de archivos



Se ejecutó la herramienta `read\_text\_file` sobre `prueba.txt`.



El servidor devolvió correctamente el contenido del archivo, incluyendo el mensaje:



```text

Estado inicial: Pendiente de lectura.

```



!\[Lectura de archivo](img/04-leer-archivo.png)





