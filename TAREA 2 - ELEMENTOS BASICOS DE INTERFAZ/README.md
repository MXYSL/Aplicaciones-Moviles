<div align="center">

# 🍃 FoodLab

## TAREA 2 · ELEMENTOS BÁSICOS DE INTERFAZ DE USUARIO

### Desarrollo de Aplicaciones Móviles Nativas
**Instituto Politécnico Nacional**  
**Escuela Superior de Cómputo**

**Ingeniería en Sistemas Computacionales**

<br>

| **Información académica** |
| :---: |
| **Alumna:** Mayra Solis Lugo |
| **Grupo:** 7CV4 |
| **Profesor:** Gabriel Hurtado Avilés |
| **Ciclo escolar:** 2026 |

<br>

![Android](https://img.shields.io/badge/Android-Nativo-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Kotlin](https://img.shields.io/badge/Kotlin-Views%20%7C%20Compose-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=for-the-badge&logo=flutter&logoColor=white)

### *Explora, prepara y organiza tus recetas.*

</div>

---

## 📱 Descripción general

La **Tarea 2 - Elementos básicos de interfaz de usuario** tiene como propósito desarrollar un catálogo interactivo que permita identificar, implementar y comparar los componentes utilizados comúnmente en el desarrollo de aplicaciones móviles.

Para realizar la actividad se desarrolló **FoodLab**, una aplicación temática relacionada con la creación, preparación y organización de recetas. En lugar de presentar los componentes de interfaz como ejemplos aislados, estos se integran dentro de situaciones propias de una aplicación de cocina.

De esta forma, un campo de texto no se presenta únicamente como un campo genérico, sino que puede formar parte del registro de una receta; los elementos de selección permiten configurar preferencias; las listas permiten explorar recetas; y los mecanismos de retroalimentación informan al usuario sobre las acciones realizadas.

El mismo concepto se implementa utilizando **tres tecnologías diferentes**, manteniendo una estructura funcional y visual equivalente. Esto permite comparar la manera en que cada plataforma resuelve problemas similares de diseño, navegación, organización e interacción.

---

## 🎯 Objetivo

El objetivo principal de la actividad es:

> **Construir un catálogo interactivo de elementos de interfaz de usuario e implementarlo en diferentes tecnologías, con el propósito de identificar los componentes básicos de una interfaz móvil, sus equivalencias entre plataformas y las diferencias entre los enfoques utilizados para construirlas.**

A partir de este objetivo, FoodLab busca integrar los elementos estudiados dentro de una aplicación funcional y visualmente consistente.

El proyecto permite analizar aspectos como:

- La construcción de interfaces móviles.
- La organización visual de la información.
- La interacción entre usuario y aplicación.
- La navegación entre diferentes áreas.
- El manejo de estados dentro de una interfaz.
- La retroalimentación proporcionada al usuario.
- La adaptación de un mismo diseño a distintas tecnologías.
- Las diferencias entre enfoques declarativos y tradicionales.
- La reutilización conceptual de una misma interfaz en diferentes plataformas.

La intención no es únicamente comprobar que un determinado componente puede mostrarse en pantalla, sino demostrar cómo puede integrarse de manera coherente dentro de una aplicación.

---

# 🍃 FoodLab

## ¿Qué es FoodLab?

**FoodLab** es un catálogo interactivo de interfaces móviles presentado como una aplicación de cocina y administración de recetas.

Su concepto parte de una idea sencilla: utilizar actividades relacionadas con la preparación de alimentos para proporcionar un contexto real a los distintos elementos de interfaz solicitados en la práctica.

En FoodLab, el usuario puede crear una receta, seleccionar características, organizar ingredientes, consultar diferentes platillos, iniciar una preparación y recibir información sobre las acciones que realiza.

Estas funciones permiten integrar diferentes tipos de interacción sin perder la coherencia temática de la aplicación.

### Concepto principal

```text
                    🍃 FOODLAB
                        │
                        ▼
              Catálogo interactivo
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
     Crear           Organizar        Explorar
    recetas          preferencias      recetas
        │               │               │
        └───────────────┼───────────────┘
                        │
                        ▼
                    Preparar
                     recetas
                        │
                        ▼
               Interacción y
                retroalimentación
```

El resultado es una aplicación en la que los elementos de interfaz forman parte de un flujo comprensible para el usuario.

---

## 💡 Concepto de la aplicación

FoodLab utiliza el contexto de una aplicación de recetas para organizar el contenido de la práctica.

La experiencia comienza en un **menú principal**, desde el cual el usuario puede acceder a seis áreas diferentes. Cada una representa un grupo de interacciones y elementos de interfaz.

Aunque cada área tiene una finalidad distinta, todas forman parte del mismo concepto.

Por ejemplo, la información registrada al crear una receta puede posteriormente utilizarse para mostrarla, prepararla o consultarla desde otras partes de la aplicación. Esto permite que FoodLab se comporte como una aplicación integrada y no únicamente como una colección de pantallas independientes.

La aplicación mantiene tres principios generales:

**Coherencia.**  
Las diferentes pantallas utilizan la misma temática, estilo visual y lenguaje.

**Interactividad.**  
Los elementos están diseñados para responder a las acciones realizadas por el usuario.

**Equivalencia.**  
Las tres implementaciones buscan representar las mismas funciones utilizando las herramientas correspondientes a cada tecnología.

---

## 📌 Alcance del proyecto

La actividad comprende el desarrollo de una misma propuesta de interfaz utilizando tres tecnologías.

El alcance incluye:

- Diseño de una pantalla principal.
- Organización del catálogo en seis áreas.
- Navegación entre las diferentes secciones.
- Integración de elementos interactivos.
- Manejo de diferentes estados visuales.
- Uso de contenido gráfico.
- Adaptación de la interfaz a las características de cada tecnología.
- Uso de una identidad visual común.
- Implementación de tema claro y oscuro cuando la plataforma lo permite.
- Generación de evidencias de funcionamiento.
- Documentación independiente de cada implementación.
- Generación de aplicaciones Android instalables.

Cada tecnología se mantiene como un proyecto independiente dentro de la misma entrega.

Esto permite desarrollar, ejecutar, documentar y evaluar cada implementación por separado sin perder la relación existente entre ellas.

---

## 🧩 Organización de FoodLab

FoodLab se divide en seis áreas principales.

| # | Área | Propósito general |
| :---: | :--- | :--- |
| **01** | **Crea tu receta** | Capturar y organizar la información necesaria para registrar una receta. |
| **02** | **Acciones de cocina** | Ejecutar diferentes acciones relacionadas con una receta y su preparación. |
| **03** | **Personaliza tu menú** | Configurar preferencias y características mediante diferentes opciones de selección. |
| **04** | **Explora recetas** | Consultar y organizar diferentes recetas mediante colecciones visuales. |
| **05** | **Cocina en progreso** | Mostrar información, estados y retroalimentación durante una preparación. |
| **06** | **Diseño de FoodLab** | Presentar diferentes formas de organización y distribución de contenido. |

Estas seis áreas se mantienen conceptualmente en todas las versiones del proyecto.

La implementación interna puede variar dependiendo de las herramientas disponibles en cada tecnología, pero el objetivo es conservar una experiencia equivalente.

---

## 🛠️ Tecnologías utilizadas

La actividad contempla tres implementaciones principales.

### 🟢 Android nativo · Views + XML

Implementación nativa para Android utilizando **Kotlin** para la lógica de la aplicación y **XML** para definir las interfaces.

Esta versión representa el enfoque tradicional de construcción de interfaces Android mediante jerarquías de vistas y archivos de layout.

La documentación específica se encuentra dentro del proyecto correspondiente.

---

### 🟣 Android nativo · Jetpack Compose

Implementación nativa para Android utilizando **Kotlin** y **Jetpack Compose**.

Esta versión utiliza un enfoque declarativo para construir y actualizar la interfaz de acuerdo con el estado de la aplicación.

Su documentación se mantiene de manera independiente dentro de su proyecto.

---

### 🔵 Flutter · Dart

Implementación desarrollada utilizando **Flutter** y **Dart**.

Esta versión utiliza el sistema de widgets de Flutter y permite construir la interfaz mediante un enfoque declarativo.

Al igual que las versiones Android, mantiene el concepto general y las seis áreas principales de FoodLab.

---

## 🔄 Equivalencia entre implementaciones

Uno de los objetivos centrales del proyecto es conservar una relación directa entre las tres versiones.

```text
                     FOODLAB
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
     Views + XML     Compose        Flutter
          │             │             │
          └─────────────┼─────────────┘
                        │
                        ▼
                Misma experiencia
                   conceptual
```

Las tecnologías no utilizan necesariamente los mismos componentes internos, pero cada versión busca ofrecer una función equivalente.

Esto permite comparar aspectos como:

| Aspecto | Views/XML | Compose | Flutter |
| :--- | :---: | :---: | :---: |
| Aplicación FoodLab | ✓ | ✓ | ✓ |
| Seis áreas principales | ✓ | ✓ | ✓ |
| Navegación | ✓ | ✓ | ✓ |
| Interacción | ✓ | ✓ | ✓ |
| Identidad visual común | ✓ | ✓ | ✓ |
| Documentación independiente | ✓ | ✓ | ✓ |
| APK Android | ✓ | ✓ | ✓ |

> El detalle de las equivalencias entre componentes se documenta dentro de los archivos correspondientes a cada implementación.

---

## 🎨 Diseño e identidad visual

Para facilitar la comparación entre tecnologías se definió una identidad visual común para FoodLab.

El diseño está inspirado en alimentos, ingredientes, recetas y cocina.

### Paleta conceptual

| Elemento | Uso |
| :--- | :--- |
| 🟢 **Verde** | Color principal e identidad de FoodLab |
| 🟠 **Naranja** | Acciones y elementos secundarios |
| ⚪ **Tonos claros** | Fondos y superficies |
| ⚫ **Tonos oscuros** | Adaptación al modo oscuro |

La interfaz utiliza además:

- Tarjetas.
- Iconografía.
- Fotografías de alimentos.
- Espaciado uniforme.
- Jerarquía tipográfica.
- Bordes redondeados.
- Organización consistente del contenido.

La intención es que una persona pueda reconocer inmediatamente que las tres aplicaciones pertenecen al mismo proyecto, aun cuando hayan sido desarrolladas utilizando tecnologías diferentes.

---

## 🧭 Navegación e interacción

La navegación general se organiza alrededor de una pantalla principal.

```text
                     MENÚ PRINCIPAL
                           │
       ┌───────────┬───────┼───────┬───────────┐
       │           │       │       │           │
       ▼           ▼       ▼       ▼           ▼
     Crear      Acciones Personalizar Explorar  ...
       │           │       │       │
       └───────────┴───────┼───────┴───────────┘
                           │
                           ▼
                    Regreso al menú
```

Desde esta pantalla el usuario puede acceder a las diferentes áreas de FoodLab y regresar posteriormente al punto principal.

Las interacciones buscan proporcionar una respuesta visual comprensible. Dependiendo de la acción, la aplicación puede actualizar contenido, modificar un estado, mostrar información adicional o navegar hacia otra área.

Además, determinadas partes de FoodLab pueden compartir información para mantener continuidad entre las diferentes secciones.

---

## 📂 Organización del repositorio

La Tarea 2 se mantiene dentro de un único directorio del repositorio general.

Su organización conceptual es la siguiente:

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
│   ├── flutter/
│   ├── eva/
│   └── compose/
│
└── apk/
```

### `README.md`

Documento principal de la actividad. Presenta el proyecto, su objetivo, alcance y organización general.

### `flutter/`

Contiene la implementación de FoodLab desarrollada con Flutter y su documentación correspondiente.

### `FoodLabEVA/`

Contiene la implementación Android nativa basada en Views y XML.

### `android-compose/`

Contiene la implementación Android nativa realizada con Jetpack Compose.

### `docs/`

Directorio destinado a las evidencias visuales y documentación complementaria de cada implementación.

### `apk/`

Contiene los archivos instalables generados como parte de la entrega.

---

## 📦 Contenido de la entrega

La entrega final contempla de manera general:

| Elemento | Descripción |
| :--- | :--- |
| **Código fuente** | Proyectos completos de las diferentes implementaciones. |
| **README general** | Presentación y organización de la actividad. |
| **README individuales** | Documentación específica de cada tecnología. |
| **Recursos** | Imágenes y demás elementos utilizados por las aplicaciones. |
| **Evidencias** | Capturas que demuestran el funcionamiento de las diferentes áreas. |
| **APK** | Aplicaciones Android generadas para la entrega. |
| **Comparación** | Correspondencia entre las diferentes implementaciones. |
| **Reflexión** | Análisis final sobre las tecnologías utilizadas. |

La separación de estos elementos permite mantener una entrega organizada y facilita la revisión individual de cada tecnología.

---

## 📖 Documentación

La documentación se encuentra dividida en dos niveles.

### Documentación general

El presente archivo:

```text
README.md
```

funciona como portada, presentación e introducción general del proyecto.

No contiene las instrucciones técnicas completas de cada aplicación, ya que estas pueden cambiar dependiendo de la tecnología utilizada.

### Documentación específica

Cada implementación contiene su propio:

```text
README.md
```

En estos archivos se documentan los aspectos particulares de cada proyecto, como su tecnología, estructura, requisitos, ejecución y características implementadas.

Esta organización evita mezclar información de Flutter con Android Views o Jetpack Compose.

---

## 📸 Evidencias

Las evidencias visuales del funcionamiento de FoodLab se almacenan dentro de:

```text
docs/
```

y se organizan de acuerdo con la tecnología correspondiente.

```text
docs/
│
├── flutter/
├── eva/
└── compose/
```

Las capturas permiten demostrar el funcionamiento de las áreas principales y comparar visualmente las diferentes implementaciones.

---

## 📲 Aplicaciones generadas

Los archivos instalables generados durante la actividad se almacenan en:

```text
apk/
```

Cada implementación Android tendrá su archivo correspondiente cuando se complete su desarrollo.

Esta separación permite distinguir claramente los archivos de entrega del código fuente y de las evidencias.

---

## ✅ Resultado esperado

Al finalizar la actividad se contará con **tres implementaciones de FoodLab**, desarrolladas mediante enfoques diferentes pero basadas en una misma propuesta funcional.

El resultado permitirá comparar de manera práctica:

- La construcción de interfaces.
- La organización de proyectos.
- La definición de componentes.
- La navegación.
- El manejo de estados.
- La interacción con el usuario.
- La adaptación visual.
- Las herramientas utilizadas por cada tecnología.

El propósito final es reconocer que una misma experiencia de usuario puede construirse mediante diferentes tecnologías, cada una con sus propias herramientas, componentes, ventajas y formas de organización.

FoodLab funciona como el elemento común que permite realizar esta comparación dentro de un escenario coherente y visualmente uniforme.

---

## 🎓 Información académica

---

<div align="center">

<br>

**Mayra Solís Lugo**  
Escuela Superior de Cómputo · Instituto Politécnico Nacional  
Ingeniería en Sistemas Computacionales · 7CV4

</div>
