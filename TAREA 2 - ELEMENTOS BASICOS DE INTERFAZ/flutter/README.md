# FoodLab - Flutter

## Descripción

Esta carpeta contiene la implementación de **FoodLab** desarrollada con Flutter y Dart.

FoodLab funciona como un catálogo interactivo de componentes de interfaz móvil utilizando una aplicación de recetas como contexto. Los elementos solicitados en la práctica se integran dentro de funciones relacionadas con la creación, preparación, selección y consulta de recetas.

La aplicación utiliza Material Design y adapta automáticamente su apariencia al tema claro u oscuro configurado en el dispositivo.

## Tecnología

- Flutter 3.47.4
- Dart 3.13.3
- Material Design 3
- Android SDK
- Android como plataforma de ejecución

## Organización de la aplicación

La pantalla principal permite acceder a seis secciones:

### 1. Crea tu receta

Permite registrar una nueva receta utilizando diferentes mecanismos de entrada.

Incluye:

- Campo de texto.
- Validación de información.
- Campo de contraseña con opción para mostrar u ocultar.
- Entrada de correo electrónico.
- Entrada telefónica.
- Entrada numérica para porciones.
- Campo multilínea para ingredientes.
- Sugerencias de categorías.
- Búsqueda.
- Mensajes de validación.

Al guardar una receta, FoodLab genera información adicional para utilizarla en otras secciones.

### 2. Acciones de cocina

Permite trabajar con la receta creada anteriormente.

Incluye:

- Botones principales.
- Botones secundarios.
- Botones con iconos.
- Botones de icono.
- Botón flotante.
- Botón flotante extendido.
- Selección segmentada.
- Estados habilitados y deshabilitados.
- Estado de carga.
- Favoritos.
- Preparación paso a paso.
- Administración de ingredientes.

### 3. Personaliza tu menú

Permite seleccionar diferentes preferencias relacionadas con una receta.

Incluye:

- Casillas de verificación.
- Estado indeterminado.
- Opciones exclusivas.
- Interruptor.
- Control de valor individual.
- Control de rango.
- Menú desplegable.
- Selector de fecha.
- Selector de hora.
- Filtros seleccionables.

### 4. Explora recetas

Presenta una colección de recetas utilizando diferentes formas de organización.

Incluye:

- Lista vertical con más de 15 recetas.
- Cuadrícula.
- Secciones.
- Recetas creadas por el usuario.
- Vista de detalle.
- Eliminación mediante deslizamiento.
- Acción para deshacer.
- Actualización mediante gesto.
- Estado vacío.
- Colecciones.
- Pestañas con contenido deslizable.

### 5. Cocina en progreso

Muestra información y retroalimentación durante la preparación.

Incluye:

- Texto con diferentes estilos.
- Imagen almacenada localmente.
- Imagen obtenida desde Internet.
- Progreso lineal determinado.
- Progreso lineal indeterminado.
- Progreso circular determinado.
- Progreso circular indeterminado.
- Mensajes temporales.
- Snackbar con acción.
- Diálogo de confirmación.
- Hoja inferior.
- Tarjetas.
- Divisores.
- Indicadores numéricos.

### 6. Diseño de FoodLab

Demuestra diferentes formas de distribuir el contenido dentro de una interfaz.

Incluye:

- Distribución horizontal.
- Distribución vertical.
- Elementos superpuestos.
- Desplazamiento vertical.
- Barra superior con acciones.
- Navegación inferior.
- Distribución proporcional del espacio.
- Búsqueda de recetas.
- Acceso a favoritos.
- Acciones rápidas.
- Acceso al perfil.

## Integración entre secciones

FoodLab utiliza un almacén compartido durante la ejecución de la aplicación.

Una receta creada en **Crea tu receta** puede ser utilizada posteriormente en otras secciones, por ejemplo:

- Acciones de cocina.
- Explora recetas.
- Cocina en progreso.
- Diseño de FoodLab.

Esto permite demostrar comunicación entre diferentes pantallas de la aplicación.

Los datos se mantienen durante la ejecución actual de FoodLab. Esta versión no implementa almacenamiento permanente mediante una base de datos.

## Estructura principal

```text
lib/
├── main.dart
├── models/
│   └── recipe.dart
├── screens/
│   ├── home_screen.dart
│   ├── text_input_screen.dart
│   ├── actions_screen.dart
│   ├── selection_screen.dart
│   ├── collections_screen.dart
│   ├── feedback_screen.dart
│   └── structure_screen.dart
├── state/
│   └── recipe_store.dart
├── theme/
│   └── app_theme.dart
└── utils/
    └── recipe_helper.dart
