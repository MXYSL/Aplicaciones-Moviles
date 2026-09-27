# TAREA 2  
# ELEMENTOS BÁSICOS DE INTERFAZ DE USUARIO

## Desarrollo de Aplicaciones Móviles Nativas

---

### Instituto Politécnico Nacional  
### Escuela Superior de Cómputo

**Ingeniería en Sistemas Computacionales**

**Materia:** Desarrollo de Aplicaciones Móviles Nativas  
**Actividad:** Tarea 2 - Elementos básicos de interfaz de usuario  
**Proyecto:** FoodLab - Catálogo interactivo de interfaces móviles  
**Alumna:** Mayra Solís Lugo  
**Grupo:** 7CV4  
**Profesor:** Gabriel Hurtado Avilés  
**Ciclo escolar:** 2026  

---

## FoodLab

**FoodLab** es el proyecto desarrollado para la Tarea 2 de la materia Desarrollo de Aplicaciones Móviles Nativas. Consiste en un catálogo interactivo de interfaces móviles presentado mediante una aplicación temática orientada a la creación, organización y consulta de recetas.

La finalidad del proyecto es reunir diferentes elementos comunes de una interfaz móvil dentro de una aplicación coherente, en lugar de presentarlos como ejemplos independientes. De esta manera, cada elemento forma parte de la experiencia general de FoodLab y puede utilizarse directamente dentro de las distintas áreas de la aplicación.

La misma propuesta se desarrolla utilizando diferentes tecnologías, conservando una temática, organización y funcionalidad equivalentes. Esto permite observar cómo una misma interfaz y sus interacciones pueden construirse mediante distintos enfoques de desarrollo móvil.

---

## Objetivo

El objetivo de la actividad es construir un catálogo interactivo de elementos de interfaz de usuario e implementarlo utilizando distintas tecnologías de desarrollo.

A través de FoodLab se busca identificar los elementos fundamentales que conforman una aplicación móvil, comprender su comportamiento y reconocer las equivalencias existentes entre las distintas plataformas y formas de construcción de interfaces.

El proyecto también permite comparar la organización de cada tecnología, la manera en que se define una interfaz, el manejo de la interacción con el usuario y la forma en que se estructura una aplicación móvil completa.

---

## Concepto de la aplicación

FoodLab utiliza el contexto de una aplicación de cocina y recetas para integrar los contenidos de la práctica.

La aplicación permite recorrer diferentes áreas relacionadas con la creación, preparación, personalización y exploración de recetas. Cada área incorpora distintos elementos de interfaz de usuario, manteniendo una presentación uniforme y una navegación consistente.

La pantalla principal funciona como punto de acceso a las seis áreas que conforman el catálogo:

1. **Crea tu receta**
2. **Acciones de cocina**
3. **Personaliza tu menú**
4. **Explora recetas**
5. **Cocina en progreso**
6. **Diseño de FoodLab**

Estas áreas conservan el mismo propósito general en cada una de las implementaciones realizadas.

---

## Tecnologías utilizadas

La actividad contempla tres implementaciones principales de la misma aplicación:

### Android nativo con Views y XML

Versión desarrollada de manera nativa para Android utilizando Kotlin y layouts XML.

### Android nativo con Jetpack Compose

Versión desarrollada de manera nativa para Android utilizando Kotlin y el enfoque declarativo proporcionado por Jetpack Compose.

### Flutter

Versión multiplataforma desarrollada utilizando Flutter y Dart.

Cada implementación cuenta con su propia documentación, código fuente y recursos necesarios para su ejecución.

---

## Organización general del proyecto

El directorio de la Tarea 2 se organiza separando cada implementación para mantener de forma independiente su código y documentación.

```text
TAREA 2 - ELEMENTOS BASICOS DE INTERFAZ/
│
├── README.md
│
├── flutter/
│   └── README.md
│
├── FoodLabEVA/
│   └── README.md
│
├── android-compose/
│   └── README.md
│
├── docs/
│
└── apk/
```

El presente archivo contiene únicamente la información general de la actividad.

Los detalles correspondientes a cada tecnología se encuentran en el archivo `README.md` incluido dentro de su respectivo proyecto.

---

## Contenido de la entrega

De manera general, la entrega está integrada por:

- Código fuente de las diferentes implementaciones de FoodLab.
- Documentación individual de cada tecnología.
- Recursos gráficos utilizados por las aplicaciones.
- Evidencias de funcionamiento.
- Capturas de las diferentes secciones.
- Archivos APK generados para las versiones correspondientes.
- Información necesaria para identificar y ejecutar cada proyecto.
- Comparación de las implementaciones realizadas.
- Reflexión sobre las diferencias encontradas durante el desarrollo.

La documentación específica se mantiene dentro de cada implementación con el propósito de evitar mezclar instrucciones o características que pertenecen exclusivamente a una tecnología.

---

## Estructura de la interfaz

FoodLab mantiene una organización común en sus diferentes versiones.

La aplicación parte de una pantalla principal desde la cual se puede acceder a las distintas áreas del catálogo. Cada sección está relacionada con una categoría de elementos de interfaz y presenta ejemplos que pueden ser utilizados directamente por el usuario.

Aunque la implementación interna cambia dependiendo de la tecnología utilizada, se conserva una experiencia visual y funcional equivalente para facilitar la comparación entre las versiones.

---

## Identidad visual

Las diferentes versiones de FoodLab comparten una misma identidad visual para que la comparación se concentre principalmente en las tecnologías utilizadas y no en cambios de diseño.

El concepto visual se encuentra relacionado con alimentos, recetas y cocina. Se utiliza una combinación de tonos verdes y cálidos, imágenes de platillos, tarjetas, iconografía y una distribución consistente del contenido.

También se considera la adaptación de la aplicación a las características visuales del dispositivo, manteniendo legibilidad, jerarquía de información y una navegación clara.

---

## Navegación

La navegación de FoodLab está diseñada alrededor de una pantalla principal y seis áreas de contenido.

El usuario puede ingresar a cada sección, interactuar con sus elementos y regresar al menú principal. Algunas áreas también comparten información con otras partes de la aplicación para mantener continuidad durante el uso.

Este comportamiento se reproduce en las diferentes tecnologías utilizando los mecanismos correspondientes a cada plataforma.

---

## Documentación

Cada proyecto contiene un archivo `README.md` independiente.

Estos documentos incluyen la información correspondiente a la tecnología utilizada, organización del proyecto, requisitos, ejecución, características implementadas y demás información necesaria para comprender cada versión.

De esta forma, este README funciona como la **portada e introducción general de la Tarea 2**, mientras que los README internos funcionan como documentación específica de cada implementación.

---

## Evidencias

Las evidencias generadas durante el desarrollo se organizan dentro del directorio:

```text
docs/
```

Este espacio está destinado a almacenar las capturas necesarias para documentar visualmente el funcionamiento de las diferentes versiones de FoodLab.

Las evidencias se organizan por tecnología para facilitar su identificación y comparación.

---

## Aplicaciones generadas

Los archivos instalables obtenidos durante el desarrollo se concentran en:

```text
apk/
```

Esta carpeta permite mantener separados los entregables ejecutables del código fuente de cada proyecto.

---

## Resultado esperado

Al finalizar la actividad se contará con distintas implementaciones de una misma aplicación móvil.

Cada versión conservará el concepto general de FoodLab, sus áreas principales y una experiencia de uso equivalente, pero estará construida mediante las herramientas y paradigmas propios de cada tecnología.

Esto permitirá observar de manera práctica las diferencias entre los enfoques de desarrollo utilizados y reconocer las equivalencias entre los elementos que conforman una interfaz móvil.

---

## Datos académicos

| Dato | Información |
|---|---|
| Institución | Instituto Politécnico Nacional |
| Escuela | Escuela Superior de Cómputo |
| Programa académico | Ingeniería en Sistemas Computacionales |
| Materia | Desarrollo de Aplicaciones Móviles Nativas |
| Actividad | Tarea 2 - Elementos básicos de interfaz de usuario |
| Proyecto | FoodLab |
| Alumna | Mayra Solís Lugo |
| Grupo | 7CV4 |
| Profesor | Gabriel Hurtado Avilés |
| Año | 2026 |

---

## Autor

**Mayra Solís Lugo**  
Ingeniería en Sistemas Computacionales  
Escuela Superior de Cómputo  
Instituto Politécnico Nacional  
Grupo 7CV4
