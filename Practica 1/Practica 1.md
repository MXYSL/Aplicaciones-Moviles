# Práctica 1 — Aplicaciones móviles

Repositorio correspondiente a la Práctica 1 de la asignatura de Aplicaciones Móviles.

El objetivo de esta práctica es desarrollar una aplicación sencilla de tipo **"Hola Mundo"** utilizando tres tecnologías diferentes para Android:

* Android XML
* Jetpack Compose
* Flutter

## Estructura del repositorio

El repositorio está organizado en carpetas independientes para cada tecnología:

```text
Aplicaciones-Moviles/
│
├── hola_mundo_xml/
│   └── Proyecto Android utilizando XML y Kotlin
│
├── hola_mundo_compose/
│   └── Proyecto Android utilizando Jetpack Compose y Kotlin
│
├── hola_mundo_flutter/
│   └── Proyecto desarrollado con Flutter y Dart
│
└── README.md
```

Cada proyecto cuenta con su propio archivo `.gitignore`, adecuado a la tecnología utilizada, para evitar subir al repositorio archivos generados automáticamente, archivos temporales, configuraciones locales y otros elementos que no forman parte del código fuente.

---

## 1. Hola Mundo — Android XML

### Descripción

Esta versión de la aplicación está desarrollada utilizando el sistema tradicional de interfaces de Android mediante **XML**.

La interfaz gráfica se define mediante archivos XML y la lógica de la aplicación está desarrollada utilizando **Kotlin**.

### Ejecución

1. Abrir la carpeta `hola_mundo_xml` en **Android Studio**.
2. Esperar a que Gradle sincronice el proyecto.
3. Seleccionar un dispositivo físico o un emulador Android.
4. Ejecutar la aplicación mediante el botón **Run ▶**.

También puede compilarse desde la terminal utilizando Gradle:

```bash
./gradlew assembleDebug
```

En Windows:

```powershell
.\gradlew.bat assembleDebug
```

---

## 2. Hola Mundo — Jetpack Compose

### Descripción

Esta versión utiliza **Jetpack Compose**, el framework moderno de Android para construir interfaces de usuario mediante código **Kotlin**.

La interfaz se construye mediante funciones `@Composable`, reduciendo la necesidad de utilizar archivos XML para definir la interfaz.

### Ejecución

1. Abrir la carpeta `hola_mundo_compose` en **Android Studio**.
2. Esperar a que finalice la sincronización de Gradle.
3. Seleccionar un dispositivo físico o un emulador Android.
4. Ejecutar la aplicación mediante el botón **Run ▶**.

También puede compilarse desde la terminal:

```powershell
.\gradlew.bat assembleDebug
```

---

## 3. Hola Mundo — Flutter

### Descripción

Esta versión está desarrollada utilizando **Flutter**, framework multiplataforma basado en **Dart**.

El proyecto utiliza Flutter para construir la interfaz y ejecutar la aplicación en un dispositivo Android mediante un emulador.

### Requisitos

* Flutter SDK
* Dart SDK
* Android SDK
* Android Emulator
* Un dispositivo Android o emulador configurado

### Ejecución

Desde la carpeta `hola_mundo_flutter`, ejecutar:

```powershell
flutter pub get
```

Este comando descarga las dependencias del proyecto.

Para comprobar los dispositivos disponibles:

```powershell
flutter devices
```

Posteriormente, ejecutar la aplicación:

```powershell
flutter run
```

También puede especificarse directamente el emulador:

```powershell
flutter run -d emulator-5554
```

---

## Tecnologías utilizadas

| Proyecto             | Tecnología      | Lenguaje     |
| -------------------- | --------------- | ------------ |
| `hola_mundo_xml`     | Android XML     | Kotlin + XML |
| `hola_mundo_compose` | Jetpack Compose | Kotlin       |
| `hola_mundo_flutter` | Flutter         | Dart         |

## Control de versiones

Cada proyecto se encuentra organizado de manera independiente dentro del repositorio y cuenta con al menos un commit descriptivo.

Ejemplos de mensajes de commit:

```text
feat: agregar proyecto Hola Mundo con XML
feat: agregar proyecto Hola Mundo con Jetpack Compose
feat: agregar proyecto Hola Mundo con Flutter
```

## Propósito de la práctica

La práctica permite comparar tres alternativas para el desarrollo de aplicaciones móviles y familiarizarse con sus respectivas herramientas, estructuras de proyecto y procesos de ejecución.

---

**Autor:** Mayra Solis Lugo

**Asignatura:** Aplicaciones Móviles

**Práctica:** 1 — Hola Mundo
