# Tarea 1. MCP y sistema de archivos: investigación e implementación

## Objetivo

Investigar el Model Context Protocol (MCP), compararlo con las APIs tradicionales e implementar un servidor MCP de sistema de archivos conectado a GitHub Copilot en Visual Studio Code.

## Entorno de implementación

| Herramienta | Versión |
|---|---|
| Sistema operativo | Windows 11 |
| Visual Studio Code | 1.138.0 |
| Node.js | 24.21.0 |
| npm | 11.19.0 |
| Git | 2.55.0.windows.5 |
| Cliente de IA | GitHub Copilot |

## Estado del proyecto

- [x] Crear estructura de directorios.
- [x] Preparar archivos de prueba.
- [x] Configurar el servidor MCP Filesystem.
- [x] Iniciar el servidor en VS Code.
- [x] Verificar que VS Code reconoce 14 herramientas.
- [ ] Comprobar los directorios autorizados.
- [ ] Realizar las operaciones sobre archivos.
- [ ] Documentar la investigación.
- [ ] Ejecutar la prueba del límite de seguridad.

## Directorio autorizado

El servidor Filesystem se configuró para operar sobre el directorio workspace-mcp.

El archivo uera-del-alcance/privado.txt se utilizará exclusivamente para comprobar las restricciones de acceso.
