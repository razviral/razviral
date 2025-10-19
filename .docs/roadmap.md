# 🗺️ Roadmap Soberano del Proyecto: razviral

| Versión | Estado      | Propietario      | Última Actualización |
| :------ | :---------- | :--------------- | :------------------- |
| v1.0    | Activo      | RaZ WriTe        | 19 de octubre de 2025  |

**IMPORTANTE:** Este documento es la **única fuente de verdad** para la planificación y ejecución del desarrollo. Anula y reemplaza cualquier roadmap o lista de funcionalidades descrita en otros documentos, incluido el `000-blueprint-razviral.md`.

## 1. Visión General y Objetivo del MVP

**Visión:** Convertir a `razviral` en un **acelerador de viralización musical** para el catálogo de RaZ WriTe, utilizando Spotify como plataforma central.

**Objetivo del MVP:** Validar el flujo de creación principal y sin fricciones:
1.  El usuario se conecta con su cuenta de Spotify.
2.  Elige una canción de RaZ WriTe.
3.  Selecciona sus propias imágenes de la galería.
4.  Añade texto simple.
5.  Renderiza un **video silencioso** de alta calidad.
6.  Lo comparte en redes sociales con instrucciones claras para añadir la canción original desde la biblioteca de la plataforma de destino (TikTok, Instagram, etc.).

## 2. Fases del Roadmap

### ✅ Fase 0: Fundación del Ecosistema (COMPLETADA)

Hemos establecido con éxito la base técnica y arquitectónica del proyecto.

*   **[✓] Workspace de Monorepo (Nx):**
    *   Configuración de `nx.json` y `package.json` bajo el enfoque moderno de "scripts mejorados con Nx".
    *   El andamiaje de Nx está validado y es funcional.
*   **[✓] Aparato `core-engine` (C++):**
    *   El entorno de compilación nativo en Windows está completamente configurado (Visual Studio Build Tools, CMake, `cl.exe`).
    *   El comando `pnpm nx build:core` compila exitosamente la librería `core_engine.dll`.
    *   La caché de Nx para el `core-engine` ha sido verificada y funciona, garantizando ciclos de desarrollo rápidos.
*   **[✓] Aparato `mobile` (Flutter/Android):**
    *   La configuración de Gradle (`build.gradle.kts`) ha sido refactorizada para producción.
    *   Las librerías nativas (`.aar`) del SDK de Spotify han sido integradas correctamente.
    *   El proyecto de Android ahora compila sin errores de dependencias nativas.

---

###  Fase 1: El Puente Soberano (FFI y Autenticación)

**Objetivo:** Establecer la comunicación bidireccional: Flutter <-> C++ y Flutter <-> Spotify.

*   **1.1. Implementar el Puente FFI (Dart -> C++):**
    *   **Tarea 1.1.1:** Crear el archivo `apps/mobile/lib/core_engine_bridge.dart`.
    *   **Tarea 1.1.2:** Dentro de `core_engine_bridge.dart`, escribir la lógica para cargar la librería dinámica (`core_engine.dll` en Windows).
    *   **Tarea 1.1.3:** Definir la firma Dart (`typedef`) para la función C `hello_from_cpp`.
    *   **Tarea 1.1.4:** Exponer una función Dart simple que llame a la función C a través del puente FFI.
    *   **Tarea 1.1.5:** En `main.dart`, llamar a esta función al presionar un botón de prueba.
    *   **Entregable:** Al presionar el botón, se debe ver en la consola el mensaje `[core-engine]: Se ha invocado la funcion 'hello_from_cpp'.`

*   **1.2. Implementar la Autenticación de Spotify (Dart -> Spotify):**
    *   **Tarea 1.2.1:** Crear una aplicación en el [Dashboard de Desarrolladores de Spotify](https://developer.spotify.com/dashboard/) para obtener el `Client ID`.
    *   **Tarea 1.2.2:** Configurar el `Redirect URI` en el dashboard de Spotify y en el proyecto de Android.
    *   **Tarea 1.2.3:** En `apps/mobile/lib/spotify_service.dart`, implementar una función `authenticate()` que use `SpotifySdk.getAuthenticationToken` con las credenciales obtenidas.
    *   **Tarea 1.2.4:** En la UI de `main.dart`, crear un botón "Conectar con Spotify".
    *   **Tarea 1.2.5:** Al presionar el botón, invocar la función `authenticate()` y manejar la respuesta.
    *   **Entregable:** El flujo de login de Spotify se completa y la app recibe un token de acceso válido.

---

### Fase 2: El Lienzo Creativo (UI/UX del MVP)

**Objetivo:** Construir las pantallas que el usuario verá para crear su video.

*   **2.1. Navegación Básica:**
    *   **Tarea 2.1.1:** Implementar un sistema de navegación simple (ej. `Navigator`) para moverse entre las pantallas.

*   **2.2. Pantalla de Selección de Medios:**
    *   **Tarea 2.2.1:** Crear una nueva pantalla/widget.
    *   **Tarea 2.2.2:** Integrar el paquete `image_picker` para permitir al usuario seleccionar múltiples imágenes de su galería.
    *   **Tarea 2.2.3:** Mostrar las imágenes seleccionadas en una vista previa.

*   **2.3. Pantalla de Selección de Música:**
    *   **Tarea 2.3.1:** Crear una nueva pantalla/widget.
    *   **Tarea 2.3.2:** Usando el token de autenticación, hacer una llamada a la **API Web de Spotify** para obtener la lista de canciones de un artista o playlist específica de RaZ WriTe.
    *   **Tarea 2.3.3:** Mostrar las canciones en una lista (título, artista, carátula).
    *   **Tarea 2.3.4:** Al tocar una canción, usar el **SDK Móvil de Spotify** (`SpotifySdk.play()`) para reproducir una vista previa de 30 segundos.

*   **2.4. Pantalla de Edición y Vista Previa:**
    *   **Tarea 2.4.1:** Crear una pantalla que muestre las imágenes seleccionadas en una secuencia simple (ej. un `PageView`).
    *   **Tarea 2.4.2:** Mientras el usuario está en esta pantalla, la canción seleccionada se reproduce en bucle.
    *   **Tarea 2.4.3:** Implementar una funcionalidad básica para añadir una superposición de texto simple sobre el video.

---

### Fase 3: El Motor de Renderizado (Core Engine V1)

**Objetivo:** Dotar al `core-engine` de la capacidad de generar un video a partir de imágenes.

*   **3.1. Integrar FFmpeg en el `core-engine`:**
    *   **Tarea 3.1.1:** Añadir FFmpeg como una dependencia en el `CMakeLists.txt` de `core-engine`.
    *   **Tarea 3.1.2:** Configurar los `include directories` y `link_libraries` para que el proyecto C++ pueda usar las funciones de FFmpeg.

*   **3.2. Implementar la API de Renderizado en C++:**
    *   **Tarea 3.2.1:** Implementar la función `razviral_project_add_media` para que almacene las rutas de los archivos de imagen.
    *   **Tarea 3.2.2:** Implementar la función `razviral_project_render`. Esta función usará FFmpeg para:
        1.  Tomar la secuencia de imágenes.
        2.  Aplicar un efecto de transición simple (ej. crossfade).
        3.  Codificar el resultado en un video **silencioso** en formato MP4.
    *   **Tarea 3.2.3 (Opcional pero recomendado):** Implementar la lógica del `progress_callback` para poder informar a la UI del progreso del renderizado.

---

### Fase 4: La Entrega (Integración Final y Lanzamiento)

**Objetivo:** Conectar todas las piezas y entregar la experiencia completa del MVP.

*   **4.1. Conectar UI con el Core Engine:**
    *   **Tarea 4.1.1:** Desde la UI de Flutter, al presionar el botón "Renderizar", llamar a las funciones del `core_engine` a través del puente FFI (`core_engine_bridge.dart`).
    *   **Tarea 4.1.2:** Pasar la lista de rutas de imágenes a `razviral_project_add_media`.
    *   **Tarea 4.1.3:** Llamar a `razviral_project_render` y mostrar una barra de progreso en la UI que se actualice con el `progress_callback`.

*   **4.2. Implementar la Lógica de Compartir:**
    *   **Tarea 4.2.1:** Una vez que el renderizado finalice, guardar el video MP4 en una ubicación temporal en el dispositivo.
    *   **Tarea 4.2.2:** Utilizar el paquete `share_plus` para abrir la hoja de compartición nativa del sistema operativo.
    *   **Tarea 4.2.3:** Antes de compartir, mostrar un diálogo o una pantalla final con instrucciones claras para el usuario, del tipo: "¡Video listo! Para finalizar, súbelo a tu historia y busca el sonido '[Nombre de la Canción]' de RaZ WriTe en la biblioteca de Instagram/TikTok."

*   **4.3. Lanzamiento:**
    *   **Tarea 4.3.1:** Realizar pruebas exhaustivas en dispositivos Android físicos.
    *   **Tarea 4.3.2:** Preparar los recursos de la tienda (íconos, capturas de pantalla).
    *   **Tarea 4.3.3:** Seguir la guía de Flutter para firmar la app y subirla a Google Play para una prueba beta interna.

## 3. Fuera del Alcance del MVP (Post-Lanzamiento)

*   Soporte para **videos** como entrada (el MVP se enfoca solo en imágenes).
*   Efectos visuales, filtros o transiciones complejas.
*   Animaciones de texto avanzadas.
*   Cuentas de usuario dentro de `razviral`.
*   Soporte para la plataforma iOS (se añadirá en una versión futura).
*   **Investigación Post-MVP:** Analizar las APIs de compartición de TikTok e Instagram para ver si es posible "pre-etiquetar" un sonido al compartir, para automatizar el último paso del usuario.

---


